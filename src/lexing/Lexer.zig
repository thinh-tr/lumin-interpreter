const std = @import("std");
const ArrayList = std.ArrayList;
const Token = @import("./token.zig").Token;
const TokenType = @import("./token_type.zig").TokenType;
const Allocator = std.mem.Allocator;
const stdout = std.io.getStdOut().writer();

// Struct chứa chức năng Lexer
pub const Lexer: type = struct {
    source: []const u8, // Trường chứa chuỗi mã nguồn cần scan
    tokens: ArrayList(Token), // List chứa token đã được scan

    const Self = @This();

    var start: usize = 0; // index bắt đầu của lexeme đang xét
    var current: usize = 0; // index hiện tại của lexeme đang xét
    var line: u128 = 1; // Vị trí dòng của lexeme đang xét
    var column: u128 = 0; // Vị trí column của token đang xét

    // Khởi tạo Lexer (Allocator tuỳ ý)
    pub fn init(allocator: Allocator, source: []const u8) Lexer {
        return Lexer{
            .source = source,
            .tokens = ArrayList(Token).init(allocator),
        };
    }

    // Huỷ Lexer
    pub fn deinit(self: *Self) void {
        self.*.tokens.deinit(); // Giải phóng bộ nhớ của list token
    }

    // Hàm scan token
    pub fn scanToken(self: *Self) !void {
        // Vòng lặp lớn qua toàn bộ source code
        while (!isAtEnd(self)) : (current += 1) { // vòng lặp tự tăng chỉ số current cho đến khi đến cuối source
            start = current; // Set start = current
            const current_char: u8 = self.*.source[current];

            // Bắt đầu kiểm tra
            switch (current_char) {
                // Nếu gặp phải khoảng trắng
                ' ' => {
                    column += 1;
                },

                // Nếu gặp ký tự xuống dòng
                '\n' => {
                    line += 1; // Tăng line lên 1
                    column = 0; // Reset column về 0
                },

                // Các char phân cách (token 1 ký tự)
                '(' => {
                    try addToken(self, Token.init(
                        .LeftPaten,
                        self.*.source[start..current + 1],
                        null,
                        line,
                        column,
                    ));
                    column += 1; // tăng column lên 1
                },
                ')' => {
                    try addToken(self, Token.init(
                        .RightPaten,
                        self.*.source[start..current + 1],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                '{' => {
                    try addToken(self, Token.init(
                        .LeftBrace,
                        self.*.source[start..current + 1],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                '}' => {
                    try addToken(self, Token.init(
                        .RightBrace,
                        self.*.source[start..current + 1],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                ',' => {
                    try addToken(self, Token.init(
                        .Comma,
                        self.*.source[start..current + 1],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                '.' => {
                    try addToken(self, Token.init(
                        .Dot,
                        self.*.source[start..current + 1],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                ':' => {
                    try addToken(self, Token.init(
                        .Colon,
                        self.*.source[start..current + 1],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                ';' => {
                    try addToken(self, Token.init(
                        .Semicolon,
                        self.*.source[start..current + 1],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                '[' => {
                    try addToken(self, Token.init(
                        .LeftSquareBracket,
                        self.*.source[start..current + 1],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                ']' => {
                    try addToken(self, Token.init(
                        .RightSquareBracket,
                        self.*.source[start..current + 1],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                
                // Trường hợp là các toán tử
                '!' => {
                    const found_token: Token = if (expectNextChar(self, '='))
                        Token.init(
                            .BangEqual,
                            self.*.source[start..current + 1],
                            null,
                            line,
                            column,
                        ) else Token.init(
                            .Bang,
                            self.*.source[start..current + 1],
                            null,
                            line,
                            column,
                        );
                    try addToken(self, found_token);
                    column += 1;
                },
                '=' => {
                    const found_token: Token = if (expectNextChar(self, '='))
                        Token.init(
                            .EqualEqual,
                            self.*.source[start..current + 1],
                            null,
                            line,
                            column,
                        ) else Token.init(
                            .Equal,
                            self.*.source[start..current + 1],
                            null,
                            line,
                            column,
                        );
                    try addToken(self, found_token);
                    column += 1;
                },
                
                else => return LexecalError.UndefinedToken,
            }
        }
    }

    // Hàm kiểm tra xem vị trí đang xét đã ở cuối của source hay chưa
    fn isAtEnd(self: *Self) bool {
        return current >= self.*.source.len; // true -> nếu như đã ở cuối source
    }

    // Hàm kiểm tra ký tự liền kề vị trí current (nếu vẫn chưa duyệt đến cuối source) nếu đúng với ký tự đang dự đoán thì sẽ tự tăng current lên 1
    fn expectNextChar(self: *Self, expect_char: u8) bool {
        if (current < self.*.source.len - 1 and self.*.source[current + 1] == expect_char) {
            current += 1;
            return true;
        } else { 
            return false;
        }
    }

    // Hàm thêm token vừa tạo vào token list
    fn addToken(self: *Self, token: Token) !void {
        try self.*.tokens.append(token);
    }

    // Báo cáo lỗi trong quá trình lexing (xuất ra dòng bị lỗi, chỉ ra cụ thể token đang bị lỗi)
    // fn reportLexecalError() !void {
    //     try stdout.
    // }
};

// Hàm chuyển u8 sang string
pub fn convertU8ToString(char: u8) []const u8 {
    const temp = [1]u8{ char };
    return temp[0..1];
}

// Error set cho các lỗi có thể xuất hiện trong quá trình scan token
pub const LexecalError: type = error{
    UndefinedToken, // Lỗi token không thể xác định
    IlligalCharacterLiteral, // Lỗi char literal không hợp lệ
    IllegalStringLiteral, // Lỗi string literal không hợp lệ
    IllegalNumberLiteral, // Lỗi number literal không hợp lệ
};

test "Lexer test" {
    const sample_source: []const u8 =
        \\=!===
    ;

    var lexer: Lexer = Lexer.init(std.testing.allocator, sample_source);
    defer lexer.deinit();
    try lexer.scanToken();

    for (lexer.tokens.items) |token| {
        try token.toString();
    }
}