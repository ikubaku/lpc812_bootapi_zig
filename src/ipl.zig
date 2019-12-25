// asmhead
comptime {
    asm (
        \\.section .text.start
        \\.globl _start
        \\_start:
        \\ .long __stack_start
        \\ .long ipl_main
        \\ .long nm_interrupt
        \\ .long hard_fault
        \\ .long irq4
        \\ .long irq5
        \\ .long irq6
        \\ .long irq7
        \\ .long irq8
        \\ .long irq9
        \\ .long irq10
        \\ .long sv_call
        \\ .long irq12
        \\ .long irq13
        \\ .long pend_sv
        \\ .long sys_tick
        \\ .long irq16
        \\ .long irq17
        \\ .long irq18
        \\ .long irq19
        \\ .long irq20
        \\ .long irq21
        \\ .long irq22
        \\ .long irq23
        \\ .long irq24
        \\ .long irq25
        \\ .long irq26
        \\ .long irq27
        \\ .long irq28
        \\ .long irq29
        \\ .long irq30
        \\ .long irq31
        \\ .long irq32
        \\ .long irq33
        \\ .long irq34
        \\ .long irq35
        \\ .long irq36
        \\ .long irq37
        \\ .long irq38
        \\ .long irq39
        \\ .long irq40
        \\ .long irq41
        \\ .long irq42
        \\ .long irq43
        \\ .long irq44
        \\ .long irq45
        \\ .long irq46
        \\ .long irq47
    );
}

extern var __bss_start: u8;
extern var __bss_end: u8;

export fn ipl_main() noreturn {
    // zero-fill bss section
    @memset(@ptrCast(*volatile [1]u8, &__bss_start), 0, @ptrToInt(&__bss_end) - @ptrToInt(&__bss_start));

    // call the main routine
    @import("main.zig").hako_main();
    
    // do infinite loop
    //while(true) {}
}

// default interrupt handler
fn default_handler() noreturn {
    while(true) {}
}

// interrupt handlers
export fn nm_interrupt() noreturn {
    default_handler();
}

export fn hard_fault() noreturn {
    default_handler();
}

export fn irq4() noreturn {
    default_handler();
}

export fn irq5() noreturn {
    default_handler();
}

export fn irq6() noreturn {
    default_handler();
}

export fn irq7() noreturn {
    default_handler();
}

export fn irq8() noreturn {
    default_handler();
}

export fn irq9() noreturn {
    default_handler();
}

export fn irq10() noreturn {
    default_handler();
}

export fn sv_call() noreturn {
    default_handler();
}

export fn irq12() noreturn {
    default_handler();
}

export fn irq13() noreturn {
    default_handler();
}

export fn pend_sv() noreturn {
    default_handler();
}

export fn sys_tick() noreturn {
    default_handler();
}

export fn irq16() noreturn {
    default_handler();
}

export fn irq17() noreturn {
    default_handler();
}

export fn irq18() noreturn {
    default_handler();
}

export fn irq19() noreturn {
    default_handler();
}

export fn irq20() noreturn {
    default_handler();
}

export fn irq21() noreturn {
    default_handler();
}

export fn irq22() noreturn {
    default_handler();
}

export fn irq23() noreturn {
    default_handler();
}

export fn irq24() noreturn {
    default_handler();
}

export fn irq25() noreturn {
    default_handler();
}

export fn irq26() noreturn {
    default_handler();
}

export fn irq27() noreturn {
    default_handler();
}

export fn irq28() noreturn {
    default_handler();
}

export fn irq29() noreturn {
    default_handler();
}

export fn irq30() noreturn {
    default_handler();
}

export fn irq31() noreturn {
    default_handler();
}

export fn irq32() noreturn {
    default_handler();
}

export fn irq33() noreturn {
    default_handler();
}

export fn irq34() noreturn {
    default_handler();
}

export fn irq35() noreturn {
    default_handler();
}

export fn irq36() noreturn {
    default_handler();
}

export fn irq37() noreturn {
    default_handler();
}

export fn irq38() noreturn {
    default_handler();
}

export fn irq39() noreturn {
    default_handler();
}

export fn irq40() noreturn {
    default_handler();
}

export fn irq41() noreturn {
    default_handler();
}

export fn irq42() noreturn {
    default_handler();
}

export fn irq43() noreturn {
    default_handler();
}

export fn irq44() noreturn {
    default_handler();
}

export fn irq45() noreturn {
    default_handler();
}

export fn irq46() noreturn {
    default_handler();
}

export fn irq47() noreturn {
    default_handler();
}
