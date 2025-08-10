const std = @import("std");

pub const BufferUri = union(enum) {
    uri: std.Uri,
    string: []const u8,
};

uri: ?BufferUri = null,
byteLength: usize,
name: ?[]const u8,
// TODO: extensions & extras implementation for Buffer
