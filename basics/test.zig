const print = @import("std").debug.print;
const expect = @import("std").testing.expect;

test "id statement" {
    const a = true;
    var x: u16 = 0;
    if (a) {
        x += 1;
    } else {
        x += 2;
    }
    try expect(x == 1);
}

test "if statement expression" {
    var x: u16 = undefined;
    var y: u64 = undefined;
    print("x={}, y={}\n", .{ x, y });
    x = if (true) 10 else 20;
    try expect(x == 10);
}

test "for" {
    const string = [_]u8{ 'a', 'b', 'c' };

    for (string) |c, i| {
        print("c={c}, i={d}\n", .{ c, i });
    }
}

test "defer" {
    var x: i16 = 5;
    {
        defer x += 2;
        try expect(x == 5);
    }
    try expect(x == 7);
}

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
};
test "error" {
    const err: FileOpenError = FileOpenError.OutOfMemory;
    try expect(err == FileOpenError.OutOfMemory);

    const maybe_error: FileOpenError!u16 = 10;
    const mustbe_error: FileOpenError!u16 = FileOpenError.OutOfMemory;
    const no_error = maybe_error catch 0;
    const has_error = mustbe_error catch -1;

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);
    print("@TypeOf(has_error){}\n", .{@TypeOf(has_error)});
    try expect(has_error == -1);
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| {
        print("err={}\n", .{err});
        try expect(err == error.Oops);
        return;
    };
}

fn failFn() error{Oops}!i32 {
    // try failingFunction();
    return 12;
}

test "try" {
    var v = failFn() catch |err| {
        print("err={}\n", .{err});
        return;
    };
    print("v={d}\n", .{v});
}

var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1;
    try failingFunction();
}

test "errdefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problems == 99);
        return;
    };
}

test "switch expression" {
    var x: i8 = 10;
    x = switch (x) {
        -1...1 => -x,
        10, 100 => @divExact(x, 10),
        else => x,
    };
    try expect(x == 1);
}

fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable,
    };
}
test "unreachable switch" {
    try expect(asciiToUpper('a') == 'A');
    try expect(asciiToUpper('A') == 'A');
    // try expect(asciiToUpper('-') == '-');
}

fn increment(num: *u8) void {
    num.* += 1;
}
test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try expect(x == 2);
}

fn total(values: []const u8) usize {
    var sum: usize = 0;
    for (values) |v| sum += v;
    return sum;
}
test "slices" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    // const slice = array[0..3];
    const slice = array[0..];
    try expect(total(slice) == 15);
}

const Value1 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    million = 1000000,
    next,
};
const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};
test "enum" {
    try expect(@enumToInt(Value1.hundred) == 100);
    try expect(@enumToInt(Value1.thousand) == 1000);
    try expect(@enumToInt(Value1.million) == 1000000);
    try expect(@enumToInt(Value1.next) == 1000001);
    try expect(Suit.clubs.isClubs());
    try expect(!Suit.spades.isClubs());
}

const Square = struct {
    x: f32,
    y: f32,
    w: f32 = 10,
    h: f32 = 3,
    fn area(self: *const Square) f32 {
        return self.w * self.h;
    }
    fn area2(self: *Square) f32 {
        return self.w * self.h;
    }
};
test "struct defaults" {
    const my_square = Square{
        .x = 25,
        .y = -50,
    };
    try expect(my_square.w == 10);
    try expect(my_square.area() == 30);
    // try expect(my_square.area2() == 30); error

    var my_square2 = Square{
        .x = 25,
        .y = -50,
    };
    try expect(my_square2.area() == 30);
    try expect(my_square2.area2() == 30);
}

test "branching on types" {
    const a = 15;
    const b: if (a < 10) f32 else i32 = 2;
    // try expect(@TypeOf(b) == f32);
    try expect(b == 2);
    try expect(@TypeOf(b) == i32);
}
