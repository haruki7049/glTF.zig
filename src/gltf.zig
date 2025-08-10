pub const Asset = @import("./gltf/asset.zig");
pub const Buffer = @import("./gltf/buffer.zig");

asset: Asset,
buffers: []const Buffer,
