const std = @import("std");
const testing = std.testing;
const ObjectMap = std.json.ObjectMap;
const Self = @This();

pub const Version = @import("./asset/version.zig");
pub const Extensions = @import("./asset/extensions.zig");
pub const Extras = union(enum) {
    object: ObjectMap,
    anyvalue: []const u8,
};

copyright: ?[]const u8 = null,
generator: ?[]const u8 = null,
version: Version,
minVersion: ?Version = null,
extensions: ?[]const u8 = null, // TODO: Implement Extensions
extras: ?Extras = null,

pub fn parseFromSlice(json_data: []const u8, allocator: std.mem.Allocator) !Self {
    const AssetJson = struct {
        copyright: ?[]const u8 = null,
        generator: ?[]const u8 = null,
        version: []const u8,
        minVersion: ?[]const u8 = null,
        extensions: ?[]const u8 = null,
        extras: ?[]const u8 = null,
    };

    const parsed_json: std.json.Parsed(AssetJson) = try std.json.parseFromSlice(AssetJson, allocator, json_data, .{});
    defer parsed_json.deinit();

    const result: Self = Self{
        .copyright = parsed_json.value.copyright,
        .generator = parsed_json.value.generator,
        .version = try Version.from_string(parsed_json.value.version),
        .minVersion = if (parsed_json.value.minVersion == null)
            null
        else
            try Version.from_string(parsed_json.value.minVersion.?),
    };

    return result;
}

test "Import tests" {
    _ = @import("./asset/version.zig");
}

test "parse_from_slice" {
    const allocator = testing.allocator;
    const json_data: []const u8 =
        \\{
        \\  "generator": "Khronos glTF Blender I/O v4.5.47",
        \\  "version": "2.0"
        \\}
    ;

    const result = try Self.parseFromSlice(json_data, allocator);

    if (result.generator == null) {
        @panic("The generator value is null");
    } else {
        try testing.expectEqualStrings(result.generator.?, "Khronos glTF Blender I/O v4.5.47");
    }

    try testing.expect(result.version.major == 2);
    try testing.expect(result.version.minor == 0);
}
