// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.

const std = @import("std");
const ParseIntError = std.fmt.ParseIntError;
const isDigit = std.ascii.isDigit;
const print = std.debug.print;
const assert = std.debug.assert;
const charToDigit = std.fmt.charToDigit;

const util = @import("util.zig");

const data = @embedFile("data/day01.txt");

const Str = []const u8;

const FindDirection = enum { start, end };

const LineIter = struct {
    _iter: std.mem.SplitIterator(u8, std.mem.DelimiterType.scalar),

    const Self = @This();

    pub fn init(input: Str) Self {
        return .{ ._iter = std.mem.splitScalar(u8, input, '\n') };
    }

    pub fn next(self: *Self) ?Str {
        if (self._iter.next()) |line| {
            const trimmed = std.mem.trim(u8, line, " \t\r");
            if (trimmed.len == 0) return self.next();
            return trimmed;
        } else {
            return null;
        }
    }
};

fn findDigit(line: Str, direction: FindDirection) error{NoDigitFound}!u8 {
    for (0..line.len) |i| {
        const char = if (direction == .start) line[i] else line[line.len - i - 1];
        return charToDigit(char, 10) catch continue;
    }
    return error.NoDigitFound;
}

fn part1(input: Str) error{NoDigitFound}!u32 {
    var answer: u32 = 0;
    var iter = LineIter.init(input);
    while (iter.next()) |line| {
        const first_digit = try findDigit(line, .start);
        const last_digit = try findDigit(line, .end);
        answer += 10 * first_digit + last_digit;
    }
    return answer;
}

fn strToNumber(str: Str) error{NoNumberFound}!u8 {
    const map = .{
        .{ "one", 1 },
        .{ "two", 2 },
        .{ "three", 3 },
        .{ "four", 4 },
        .{ "five", 5 },
        .{ "six", 6 },
        .{ "seven", 7 },
        .{ "eight", 8 },
        .{ "nine", 9 },
    };
    inline for (map) |entry| {
        const diffIdx: ?usize = std.mem.indexOfDiff(u8, entry[0], str);
        if (diffIdx == null or diffIdx.? >= entry[0].len) return entry[1];
    }
    return error.NoNumberFound;
}

fn findNumber(line: Str, direction: FindDirection) error{NoNumberFound}!u8 {
    for (0..line.len) |i| {
        const idx = if (direction == .start) i else line.len - i - 1;
        if (charToDigit(line[idx], 10) catch null) |d| return d;
        if (strToNumber(line[idx..]) catch null) |n| return n;
    }
    return error.NoNumberFound;
}

fn part2(input: Str) error{NoNumberFound}!u32 {
    var answer: u32 = 0;
    var iter = LineIter.init(input);
    while (iter.next()) |line| {
        const first_num = try findNumber(line, .start);
        const last_num = try findNumber(line, .end);
        answer += 10 * first_num + last_num;
    }
    return answer;
}

pub fn main() !void {
    try util.runPart(part1, data);
    print("\n", .{});
    try util.runPart(part2, data);
}

test "part1" {
    const input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    const answer = try part1(input);
    assert(answer == 142);
}

test "part2" {
    const input =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;
    const answer = try part2(input);
    assert(answer == 281);
}
