const std = @import("std");
const Builder = std.build.Builder;
const builtin = @import("builtin");

pub fn build(b: *Builder) void {
    const bin_name = "lpc812_bootapi_zig.bin";
    
    const mode = b.standardReleaseOptions();
    const bin = b.addExecutable(bin_name, "src/ipl.zig");
    bin.setOutputDir("Debug");
    bin.setBuildMode(mode);

    // Set the target to thumbv6m-freestanding-eabi
    bin.setTarget(builtin.Arch{ .thumb = builtin.Arch.Arm32.v6m }, builtin.Os.freestanding, builtin.Abi.eabi);

    // Use the custom linker script to build a baremetal program
    bin.setLinkerScriptPath("src/linker.ld");
    const run_objcopy = b.addSystemCommand([_][]const u8 {
        "llvm-objcopy", bin.getOutputPath(),
        "-O", "binary",
        bin_name,
    });
    run_objcopy.step.dependOn(&bin.step);
    
    b.default_step.dependOn(&run_objcopy.step);
}
