const std = @import("std");
const Builder = std.build.Builder;
const Pkg = std.build.Pkg;

const pkgs = struct {
    const major = Pkg{
        .name = "major",
        .source = .{ .path = "./major.zig" },
        .dependencies = &[_]Pkg{
            Pkg{
                .name = "minor",
                .source = .{ .path = "../minor/minor.zig" },
                .dependencies = null,
            },
        },
    };
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe_tests = b.addTest("./main_test.zig");
    exe_tests.addPackage(pkgs.major);
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
