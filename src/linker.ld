ENTRY(_start)

// Change LENGTHs here if you are using LPC811 or LPC810
MEMORY {
    FLASH : ORIGIN = 0x00000000, LENGTH = 16K
    RAM : ORIGIN = 0x10000000, LENGTH = 4K
}

SECTIONS {

    /DISCARD/ : {
        *(.ARM.exidx)
    }
    
    .text : {
        __test_start = .;
        __start = .;
        KEEP(*(.text.start))
        *(.text*)
        __text_end = .;
    } > FLASH

    .rodata : {
        __rodata_start = .;
        *(.rodata*)
        __rodata_end = .;
    } > FLASH
    
    .data : {
        __data_start = .;
        *(.data*)
        __data_end = .;
    } > RAM
    
    . = ALIGN(4);

    .bss : {
        __bss_start = .;
        *(.bss*)
        __bss_end = .;
    } > RAM
    
    .stack : {
        __stack_end = .;
        __stack_start = ORIGIN(RAM) + LENGTH(RAM) - 4;
    } > RAM
}
