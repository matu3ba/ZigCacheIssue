const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.complex.Complex;

const major = @import("../major.zig");
const Foo = major.Foo;

pub fn beta(x: anytype) bool {
    const T = @TypeOf(x);

    switch (T) {
        []f32, Foo(f32) => {
            return false;
        },
        []f64, Foo(f64) => {
            return true;
        },
        else => {
            @compileError("type not implemented");
        },
    }
}

// --- TESTS -----------------------------

test "beta array" {
    const T = f64;
    const n = 8;
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var x = try allocator.alloc(T, n);
    var result = major.beta(x);
    try std.testing.expectEqual(result, true);
}
