const std = @import("std");
const ArrayList = std.ArrayList;
const Token = @import("./Token.zig").Token;
const TokenType = @import("./TokenType.zig").TokenType;
const page_allocator = std.heap.page_allocator;
const reportError = @import("../main.zig").reportError;

pub const Scanner = struct {
    source: []u8,   // Whole source file
    tokens: ArrayList(Token),

    // Thuộc tính xác định vị trí đang được scan
    start: i128 = 0, // vị trí bắt đầu
    current: i128 = 0,   // vị trí hiện tại
    line: i128 = 1, // ví trí dòng code

    const Self = @This();

    pub fn init(source: []u8) Scanner {
        return Scanner{
            .source = source,
            .tokens = ArrayList(Token).init(page_allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        self.*.tokens.deinit();    // Giải phóng tokens_list
    }

    // Scan toàn bộ source code và thêm các token tìm được vào tokens_list
    // pub fn scanTokens(self: *Self) void {

    // }

    // Hàm kiểm tra kết thúc source code
    fn isAtEnd(self: *Self) bool {
        // Nếu cuurent bằng hoặc lớn hơn đội dài source code thì kết thúc
        return self.*.current >= self.*.source.len;
    }
};

pub const ScannerError = error {
    UnexpectedToken,
};