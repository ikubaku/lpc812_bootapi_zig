const ROM_DRIVER_TABLE_PTR_ADDR = 0x1FFF1FF8;

const USART0_BASE_ADDR = 0x40064000;
const USART1_BASE_ADDR = 0x40068000;
const USART2_BASE_ADDR = 0x4006C000;

const SYSAHBCLKCTRL_ADDR = 0x40048080;
const PINASSIGN0_ADDR = 0x4000C000;

pub const UartPort = enum {
    USART0,
    USART1,
    USART2,
};

const UartConfig = extern struct {
    sys_clk_in_hz: u32,
    baudrate_in_hz: u32,
    config: u8,
    sync_mod: u8,
    error_en: u16,
};

const UartParam = extern struct {
    buffer: [*]const u8,
    size: u32,
    transfer_mode: u16,
    driver_mode: u16,
    callback_func_pt: stdcallcc fn (err_code: u32, n: u32) void,
};

const UartParamMutableBuffer = extern struct {
    buffer: [*]u8,
    size: u32,
    transfer_mode: u16,
    driver_mode: u16,
    callback_func_pt: stdcallcc fn (err_code: u32, n: u32) void,
};

const UartDriverRoutines = extern struct {
    uart_get_mem_size: stdcallcc fn () u32,
    uart_setup: stdcallcc fn (base_addr: u32, ram: *[40]u8) *c_void,
    uart_init: stdcallcc fn (handle: *c_void, set: UartConfig) u32,
    uart_get_char: stdcallcc fn (handle: *c_void) u8,
    uart_put_char: stdcallcc fn (handle: *c_void, data: u8) void,
    uart_get_line: stdcallcc fn (handle: *c_void, param: UartParamMutableBuffer) u32,
    uart_put_line: stdcallcc fn (handle: *c_void, param: UartParam) u32,
    uart_isr: stdcallcc fn (handle: *c_void) void,
};

const Uart = struct {
    peripheral_ram: [40]u8,
    routine_table: *UartDriverRoutines,

    pub fn init_port(self: *Uart, port: UartPort) *c_void {
        return switch(port) {
            UartPort.USART0 => self.routine_table.uart_setup(USART0_BASE_ADDR, &(self.*.peripheral_ram)),
            UartPort.USART1 => self.routine_table.uart_setup(USART1_BASE_ADDR, &(self.*.peripheral_ram)),
            UartPort.USART2 => self.routine_table.uart_setup(USART2_BASE_ADDR, &(self.*.peripheral_ram)),
        };
    }

    pub fn configure_port(self: Uart, port_handle: *c_void, baud_rate: u32) u32 {
        return self.routine_table.uart_init(port_handle,
                                 UartConfig {
                                     .sys_clk_in_hz = 12000000,
                                     .baudrate_in_hz = baud_rate,
                                     .config = 0b00000001,
                                     .sync_mod = 0b00000000,
                                     .error_en = 0x0000,
        });
    }
    
    pub fn put_char(self: Uart, port_handle: *c_void, data: u8) void {
        self.routine_table.uart_put_char(port_handle, data);
    }

    pub fn println(self: Uart, port_handle: *c_void, data: [*]const u8, bufsize: u32) void {
        _ = self.routine_table.uart_put_line(port_handle,
                                             UartParam {
                                                 .buffer = data,
                                                 .size = bufsize,
                                                 .transfer_mode = 0x0002,
                                                 .driver_mode = 0x0000,
                                                 .callback_func_pt = undefined,
        });
    }
    
    pub fn gets(self: Uart, port_handle: *c_void, buf: [*]u8, bufsize: u32) void {
        _ = self.routine_table.uart_get_line(port_handle,
                                             UartParamMutableBuffer {
                                                 .buffer = buf,
                                                 .size = bufsize,
                                                 .transfer_mode = 0x0002,
                                                 .driver_mode = 0x0000,
                                                 .callback_func_pt = undefined,
        });
    }
};

pub fn init_uart() Uart {
    // Source the clock to all the USART blocks
    const clk_ctl_ptr = @intToPtr(*volatile u32, SYSAHBCLKCTRL_ADDR);
    clk_ctl_ptr.* |= 0x0001C000;

    // Set the pin assignments
    const pin_assign0_ptr = @intToPtr(*volatile u32, PINASSIGN0_ADDR);
    pin_assign0_ptr.* = 0xFFFF0004; // CTS=none, RTS=none, RXD=P0_0, TXD=P0_4
    
    const driver_table_addr = @intToPtr(*u32, ROM_DRIVER_TABLE_PTR_ADDR).*;
    const uart_driver_table_addr = @intToPtr(*u32, driver_table_addr + 0x24).*;
    const res = Uart {
        .peripheral_ram = [_]u8{0} ** 40,
        .routine_table = @intToPtr(*UartDriverRoutines, uart_driver_table_addr),
    };

    return res;
}
