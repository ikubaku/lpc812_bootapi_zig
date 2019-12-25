const gpio = @import("hal/gpio.zig");
const uart = @import("hal/uart.zig");

const RECV_BUFSIZE = 64;

pub fn hako_main() noreturn {
    var recv_buf: [RECV_BUFSIZE]u8 = [_]u8{0} ** RECV_BUFSIZE;
    
    gpio.led_init();

    var uart_api = uart.init_uart();

    // Use USART0 transciever
    const uart0 = uart_api.init_port(uart.UartPort.USART0);
    _ = uart_api.configure_port(uart0, 9600);

    // Do the echo back
    uart_api.println(uart0, c"Hello world from ziglang!!", 32);
    uart_api.println(uart0, c"Do the echo-back task:", 32);
    
    while(true) {
        gpio.led_on();
        uart_api.gets(uart0, &recv_buf, RECV_BUFSIZE);
        
        gpio.led_off();
        uart_api.println(uart0, &recv_buf, RECV_BUFSIZE);
    }
}
