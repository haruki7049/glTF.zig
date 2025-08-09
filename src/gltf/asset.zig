const std = @import("std");
const testing = std.testing;
const ObjectMap = std.json.ObjectMap;
const Self = @This();

pub const Version = @import("./asset/version.zig");
pub const Extras = union(enum) {
    object: ObjectMap,
    anyvalue: []const u8,
};

copyright: ?[]const u8,
generator: ?[]const u8,
version: Version,
minVersion: ?Version,
extensions: ?ObjectMap,
extras: Extras,

test "Import tests" {
    _ = @import("./asset/version.zig");
}

test "parse_from_slice" {
    // const allocator = testing.allocator;
    // const json_data: []const u8 =
    //     \\{
    //     \\  "generator": "Khronos glTF Blender I/O v4.5.47",
    //     \\  "version": "2.0"
    //     \\}
    // ;

    std.debug.print("{s}\n", .{@typeName(Self)});

    // const result: std.json.Parsed(Self) = try std.json.parseFromSlice(Self, allocator, json_data, .{});

    // if (result.value.generator == null) {
    //     @panic("The generator value is null");
    // } else {
    //     try testing.expectEqual(result.value.generator.?, "Khronos glTF Blender I/O v4.5.47");
    // }

    // try testing.expect(result.value.version.major == 2);
    // try testing.expect(result.value.version.minor == 0);
}
