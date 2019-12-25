// HAL and BSP

const GPIO_BASE_ADDR = 0xA0000000;
const B15_ADDR = GPIO_BASE_ADDR + 0x000f;
const DIR0_ADDR = GPIO_BASE_ADDR + 0x2000;


pub const IODir = enum {
    Input,
    Output,
};

pub fn set_dir(pin: u5, dir: IODir) void {
    const b = @intToPtr(* volatile u32, DIR0_ADDR);
    const bit: u32 = 0x00000001;
    switch(dir) {
        IODir.Input => b.* &= ~(bit << pin),
        IODir.Output => b.* |= (bit << pin),
    }
}

pub fn led_init() void {
    set_dir(15, IODir.Output);
}

pub fn led_on() void {
    const b = @intToPtr(* volatile u8, B15_ADDR);
    b.* = 0x00;
}

pub fn led_off() void {
    const b = @intToPtr(* volatile u8, B15_ADDR);
    b.* = 0x01;
}
