const std = @import("std");
const testing = std.testing;
const Self = @This();

major: usize,
minor: usize,

pub fn to_string(self: Self, allocator: std.mem.Allocator) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{d}.{d}", .{ self.major, self.minor });
}

pub fn from_string(data: []const u8) !Self {
    var iter = std.mem.splitScalar(u8, data, '.');

    const major_str: []const u8 = iter.first();
    const minor_str: []const u8 = iter.next().?;

    const major: usize = try std.fmt.parseInt(usize, major_str, 10);
    const minor: usize = try std.fmt.parseInt(usize, minor_str, 10);

    return Self{ .major = major, .minor = minor };
}

test "to_string" {
    const allocator = testing.allocator;

    const first_zero: Self = Self{ .major = 1, .minor = 0 };
    const first_zero_str: []const u8 = try first_zero.to_string(allocator);
    try testing.expectEqualStrings(first_zero_str, "1.0");
    allocator.free(first_zero_str);

    const second_zero: Self = Self{ .major = 2, .minor = 0 };
    const second_zero_str: []const u8 = try second_zero.to_string(allocator);
    try testing.expectEqualStrings(second_zero_str, "2.0");
    allocator.free(second_zero_str);
}

test "from_string" {
    const first_zero: Self = try Self.from_string("1.0");
    try testing.expect(first_zero.major == 1);
    try testing.expect(first_zero.minor == 0);

    const second_zero: Self = try Self.from_string("2.0");
    try testing.expect(second_zero.major == 2);
    try testing.expect(second_zero.minor == 0);
}
