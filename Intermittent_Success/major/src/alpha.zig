const std = @import("std");
pub const major = @import("major");

test "alpha foo" {
    const result = true;
    try std.testing.expectEqual(result, true);
}
