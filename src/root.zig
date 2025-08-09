const std = @import("std");
const testing = std.testing;

pub const Gltf = @import("./gltf.zig");

test "Import tests" {
    _ = @import("./gltf.zig");
}
