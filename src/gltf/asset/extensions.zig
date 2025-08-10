schema: []const u8,
id: []const u8,
title: []const u8,
type: []const u8,
description: []const u8,
properties: []const u8,
additionalProperties: AdditionalProperties,

pub const AdditionalProperties = struct {
    type: []const u8,
};
