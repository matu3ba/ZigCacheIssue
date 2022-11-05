const std = @import("std");
const Complex = std.math.complex.Complex;

const Allocator = std.mem.Allocator;

const print = std.debug.print;

pub fn Foo(comptime T: type) type {
    comptime var U: type = usize;

    switch (T) {
        f32,
        f64,
        => {},
        Complex(f32), Complex(f64) => {},
        else => @compileError("requested Foo type is not allowed"),
    }

    return struct {
        const Self = @This();
        val: []T,

        pub fn fill(self: Self, new_val: T) void {
            for (self.val) |_, i| {
                self.val[i] = new_val;
            }
        }

        pub fn init(allocator: Allocator, len: U) !Self {
            return Self{
                .val = try allocator.alloc(T, len),
            };
        }

        pub fn zeros(self: Self) void {
            switch (T) {
                f32, f64 => {
                    for (self.val) |_, i| {
                        self.val[i] = 0;
                    }
                },
                Complex(f32), Complex(f64) => {
                    for (self.val) |_, i| {
                        self.val[i].re = 0;
                        self.val[i].im = 0;
                    }
                },
                else => @compileError("requested Foo type is not allowed"),
            }
        }
    };
}

//-----------------------------------------------

test "foo methods zeros - real \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Foo(R).init(allocator, 3);
        x.zeros();

        try std.testing.expectApproxEqAbs(x.val[0], 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[1], 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[2], 0.0, eps);
    }
}
