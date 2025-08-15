const std = @import("std");
const testing = std.testing;
const Self = @This();

pub const BufferUri = union(enum) {
    uri: std.Uri,
    string: []const u8,

    fn parseFromSlice(data: []const u8) std.Uri.ParseError!BufferUri {
        const parsed_data: std.Uri.ParseError!std.Uri = std.Uri.parse(data);

        if (parsed_data == error.UnexpectedCharacter)
            return BufferUri{ .string = data };

        const result: std.Uri = try parsed_data;

        return BufferUri{ .uri = result };
    }

    test "parseFromSlice with Uri" {
        const data: []const u8 = "https://example.com/data.bin";
        const result: BufferUri = try BufferUri.parseFromSlice(data);
        try testing.expectEqual(std.Uri.parse(data), result.uri);
    }

    test "parseFromSlice with string" {
        const data: []const u8 = "local_data.bin";
        const result: BufferUri = try BufferUri.parseFromSlice(data);
        try testing.expectEqual(data, result.string);
    }

    test "parseFromSlice with path" {
        const data: []const u8 = "./local_data.bin";
        const result: BufferUri = try BufferUri.parseFromSlice(data);
        try testing.expectEqual(data, result.string);
    }
};

uri: ?BufferUri = null,
byteLength: usize,
name: ?[]const u8,
extensions: ?[]const u8 = null,
extras: ?[]const u8 = null,

pub fn parseFromSlice(json_data: []const u8, allocator: std.mem.Allocator) !Self {
    const BufferJson = struct {
        uri: ?[]const u8 = null,
        byteLength: usize,
        name: ?[]const u8 = null,
        extensions: ?[]const u8 = null,
        extras: ?[]const u8 = null,
    };

    const parsed_json = try std.json.parseFromSlice(BufferJson, allocator, json_data, .{});
    defer parsed_json.deinit();

    const result: Self = Self{
        .uri = if (parsed_json.value.uri == null)
            null
        else
            try BufferUri.parseFromSlice(parsed_json.value.uri.?),

        .byteLength = parsed_json.value.byteLength,
        .name = parsed_json.value.name,
        .extensions = parsed_json.value.extensions,
        .extras = parsed_json.value.extras,
    };

    if (result.byteLength < 1)
        return error.TooSmallByteLength;

    return result;
}

const ParseError = error{
    TooSmallByteLength,
};

test "parseFromSlice with correct Uri" {
    const allocator = testing.allocator;
    const data: []const u8 =
        \\{
        \\  "uri": "https://example.com/data.bin",
        \\  "byteLength": "10"
        \\}
    ;

    const result = try Self.parseFromSlice(data, allocator);

    try testing.expectEqualStrings(result.uri.?.uri.scheme, "https");
    try testing.expectEqual(result.byteLength, 10);
}

test "parseFromSlice with correct data" {
    const allocator = testing.allocator;
    const data: []const u8 =
        \\{
        \\  "uri": "./data.bin",
        \\  "byteLength": "10"
        \\}
    ;

    const result = try Self.parseFromSlice(data, allocator);

    try testing.expectEqualStrings(result.uri.?.string, "./data.bin");
    try testing.expectEqual(result.byteLength, 10);
}

test "parseFromSlice with byteLength 0" {
    const allocator = testing.allocator;
    const data: []const u8 =
        \\{
        \\  "uri": "./data.bin",
        \\  "byteLength": "0"
        \\}
    ;

    try testing.expectError(error.TooSmallByteLength, Self.parseFromSlice(data, allocator));
}
