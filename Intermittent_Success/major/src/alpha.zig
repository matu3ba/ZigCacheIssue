const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.complex.Complex;

pub  const major = @import("major");
const Foo = major.Foo;

const pi = math.pi;

pub fn alpha(x: anytype) bool {

    const T  = @TypeOf(x);

    switch(T) {
        []f32, Foo(f32) => { return false; },
        []f64, Foo(f64) => { return true; },
        else => { @compileError("type not implemented");},
    }
}


test "\t alpha \t slice\n" {

    const T = f64;

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var x = try allocator.alloc(T, 4);

    var result = major.alpha(x);

    try std.testing.expectEqual(result, true);
}

test "\t alpha \t  foo\n" {

    const T = f64;

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var x = try Foo(T).init(allocator, 4);

    var result = major.alpha(x);

    try std.testing.expectEqual(result, true);
}

