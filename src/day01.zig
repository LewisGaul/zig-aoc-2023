// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.

const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const ParseIntError = std.fmt.ParseIntError;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const charToDigit = std.fmt.charToDigit;
const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

const isDigit = std.ascii.isDigit;

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

pub fn main() !void {
    try util.runPart(part1, data);
    print("\n", .{});
    // try util.runPart(part2, data);
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
