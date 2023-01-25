const std = @import("std");
const module = @import("module.zig");

pub fn main() void {
  var inferred_constant = @as(i32, 3);

  std.debug.print("{d}\n", .{inferred_constant});

  const a =[5]u8{'h', 'e', 'l', 'l', 'o'};
  std.debug.print("{d}\n", .{a.len});

  module.greet("Hello");
}
