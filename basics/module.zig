const std = @import("std");

pub fn greet(msg: []const u8) void {
    std.debug.print("{s}!\n", .{msg});
}
