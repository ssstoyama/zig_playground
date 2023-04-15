const std = @import("std");

pub fn main() void {
    // NG
    // const add2 = fn(x: isize) isize {
    // return x+2;
    // };

    // 匿名構造体で関数を定義、その関数を変数 add にセット
    const add2 = struct {
        pub fn f(x: isize) isize {
            return x + 2;
        }
    }.f;

    std.debug.print("add2(3)={d}\n", .{add2(3)});

    // const y = 100; でも OK
    comptime var y = 100;
    const addY = struct {
        pub fn f(x: isize) isize {
            // y は comptime な値でないとコンパイルエラーになる
            return x + y;
        }
    }.f;

    std.debug.print("addY(3)={d}\n", .{addY(3)});

    std.debug.print("add1000(add2)(3)={d}\n", .{add1000(add2)(3)});
    std.debug.print("add1000(addY)(3)={d}\n", .{add1000(addY)(3)});
}

fn add1000(comptime f: fn (x: isize) isize) fn (isize) isize {
    return struct {
        pub fn add(x: isize) isize {
            return f(x) + 1000;
        }
    }.add;
}
