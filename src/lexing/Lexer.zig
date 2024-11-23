const std = @import("std");
const ArrayList = std.ArrayList;
const Token = @import("./Token.zig").Token;
const TokenType = @import("./TokenType.zig").TokenType;
const Allocator = std.mem.Allocator;

// Struct chứa chức năng Lexer
pub const Lexer = struct {
    source: []const u8, // Trường chứa chuỗi mã nguồn cần scan
    tokens: ArrayList(Token), // List chứa token đã được scan

    var start: usize = 0; // index bắt đầu của lexeme đang xét
    var current: usize = 0; // index hiện tại của lexeme đang xét
    var line: u128 = 1; // Vị trí dòng của lexeme đang xét
    var column: u128 = 0;   // Vị trí column của token đang xét

    // Khởi tạo Lexer (Allocator tuỳ ý)
    pub fn init(allocator: Allocator, source: []const u8) Lexer {
        return Lexer{
            .source = source,
            .tokens = ArrayList(Token).init(allocator),
        };
    }

    // Huỷ Lexer
    pub fn deinit(self: @This()) void {
        self.tokens.deinit(); // Giải phóng bộ nhớ của list token
    }

    // Hàm scan token
    pub fn scanToken(self: @This()) !void {
        // Vòng lặp lớn qua toàn bộ source code
        while (!isAtEnd()) : (current += 1) { // vòng lặp tự tăng chỉ số current cho đến khi đến cuối source
            start = current;

            // Bắt đầu kiểm tra
            switch (self.source[current]) {
                // Nếu gặp phải khoảng trắng
                ' ', '\t' => {
                    column += 1;
                },

                // Nếu gặp ký tự xuống dòng
                '\n' => {
                    line += 1;  // Tăng line lên 1
                    column = 0; // Reset column về 0
                },

                // Các char phân cách (token 1 ký tự)
                '(' => {
                    addToken(self, Token.init(
                        .LeftPaten,
                        self.source[current],
                        null,
                        line,
                        column,
                    ));
                    column += 1;    // tăng column lên 1
                },
                ')' => {
                    addToken(self, Token.init(
                        .RightPaten,
                        self.source[current],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                '{' => {
                    addToken(self, Token.init(
                        .LeftBrace,
                        self.source[current],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                '}' => {
                    addToken(self, Token.init(
                        .RightBrace,
                        self.source[current],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                ',' => {
                    addToken(self, Token.init(
                        .Comma,
                        self.source[current],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                '.' => {
                    addToken(self, Token.init(
                        .Dot,
                        self.source[current],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                ':' => {
                    addToken(self, Token.init(
                        .Colon,
                        self.source[current],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                ';' => {
                    addToken(self, Token.init(
                        .Semicolon,
                        self.source[current],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                '[' => {
                    addToken(self, Token.init(
                        .LeftSquareBracket,
                        self.source[current],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                ']' => {
                    addToken(self, Token.init(
                        .RightSquareBracket,
                        self.source[current],
                        null,
                        line,
                        column,
                    ));
                    column += 1;
                },
                else => return LexecalError.UndefinedToken,
            }
        }
    }

    // Hàm kiểm tra xem vị trí đang xét đã ở cuối của source hay chưa
    fn isAtEnd(self: @This()) bool {
        return current >= self.source.len; // true -> nếu như đã ở cuối source
    }

    // Hàm kiểm tra ký tự liền kề vị trí current (nếu vẫn chưa duyệt đến cuối source)
    fn peekNextChar(self: @This()) ?u8 {
        return if (current < self.source.len - 1) self.source[current + 1] else null;
    }

    // Hàm thêm token vừa tạo vào token list
    fn addToken(self: @This(), token: Token) !void {
        try self.tokens.append(token);
    }
};

// Error set cho các lỗi có thể xuất hiện trong quá trình scan token
pub const LexecalError: type = error{
    UndefinedToken, // Lỗi token không thể xác định
    IlligalCharacterLiteral, // Lỗi char literal không hợp lệ
    IllegalStringLiteral, // Lỗi string literal không hợp lệ
    IllegalNumberLiteral, // Lỗi number literal không hợp lệ
};


test "Lexer test" {
    const sample_source: []const u8 = 
        \\(){},.:;[]
        \\(){},.:;[]
    ;

    var lexer: Lexer = Lexer.init(std.testing.allocator, sample_source);
    defer lexer.deinit();
    lexer.scanToken();

    for (lexer.tokens.items) |token| {
        token.toString();
    }
}