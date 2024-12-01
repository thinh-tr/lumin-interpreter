const std = @import("std");
const ArrayList = std.ArrayList;
const Token = @import("./Token.zig");
const TokenType = @import("./TokenType.zig").TokenType;
const Allocator = std.mem.Allocator;
const stdout = std.io.getStdOut().writer();
const ascii = std.ascii;

const Self: type = @This(); // Tham chiếu đến kiểu Lexer

// Struct chứa chức năng Lexer
source: []const u8, // Trường chứa chuỗi mã nguồn cần scan
tokens: ArrayList(Token), // List chứa token đã được scan

var start: usize = 0; // index bắt đầu của lexeme đang xét
var current: usize = 0; // index hiện tại của lexeme đang xét
var line: u128 = 1; // Vị trí dòng của lexeme đang xét
var column: u128 = 0; // Vị trí column của token đang xét

// Khởi tạo Lexer (Allocator tuỳ ý)
pub fn init(allocator: Allocator, source: []const u8) Self {
    return Self{
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

            // Các char phân cách
            '(' => {
                try addToken(self, Token.init(.LeftPaten, self.*.source[start .. current + 1], null, line, column));
            },
            ')' => {
                try addToken(self, Token.init(.RightPaten, self.*.source[start .. current + 1], null, line, column));
            },
            '{' => {
                try addToken(self, Token.init(.LeftBrace, self.*.source[start .. current + 1], null, line, column));
            },
            '}' => {
                try addToken(self, Token.init(.RightBrace, self.*.source[start .. current + 1], null, line, column));
            },
            ',' => {
                try addToken(self, Token.init(.Comma, self.*.source[start .. current + 1], null, line, column));
            },
            '.' => {
                try addToken(self, Token.init(.Dot, self.*.source[start .. current + 1], null, line, column));
            },
            ':' => {
                try addToken(self, Token.init(.Colon, self.*.source[start .. current + 1], null, line, column));
            },
            ';' => {
                try addToken(self, Token.init(.Semicolon, self.*.source[start .. current + 1], null, line, column));
            },
            '[' => {
                try addToken(self, Token.init(.LeftSquareBracket, self.*.source[start .. current + 1], null, line, column));
            },
            ']' => {
                try addToken(self, Token.init(.RightSquareBracket, self.*.source[start .. current + 1], null, line, column));
            },

            // Trường hợp các char là các toán tử
            '^' => {
                try addToken(self, Token.init(.Circumflex, self.*.source[start .. current + 1], null, line, column));
            },
            '!' => {
                const token: Token = if (expectNextChar(self, '='))
                    Token.init(.BangEqual, self.*.source[start .. current + 1], null, line, column)
                else
                    Token.init(.Bang, self.*.source[start .. current + 1], null, line, column);
                try addToken(self, token);
            },
            '=' => {
                const token: Token = if (expectNextChar(self, '='))
                    Token.init(.EqualEqual, self.*.source[start .. current + 1], null, line,column)
                else
                    Token.init(.Equal, self.*.source[start .. current + 1], null, line, column);
                try addToken(self, token);
            },
            '>' => {
                const token: Token = if (expectNextChar(self, '='))
                    Token.init(.GreaterEqual, self.*.source[start .. current + 1], null, line, column)
                else
                    Token.init(.Greater, self.*.source[start .. current + 1], null, line, column);
                try addToken(self, token);
            },
            '<' => {
                const token: Token = if (expectNextChar(self, '='))
                    Token.init(.LesserEqual, self.*.source[start .. current + 1], null, line, column)
                else
                    Token.init(.Lesser, self.*.source[start .. current + 1], null, line, column);
                try addToken(self, token);
            },
            '+' => {
                const token: Token = if (expectNextChar(self, '='))
                    Token.init(.PlusEqual, self.*.source[start .. current + 1], null, line, column)
                else
                    Token.init(.Plus, self.*.source[start .. current + 1], null, line, column);
                try addToken(self, token);
            },
            '-' => {
                const token: Token = if (expectNextChar(self, '='))
                    Token.init(.MinusEqual, self.*.source[start .. current + 1], null, line, column)
                else
                    Token.init(.Minus, self.*.source[start .. current + 1], null, line, column);
                try addToken(self, token);
            },
            '*' => {
                const token: Token = if (expectNextChar(self, '='))
                    Token.init(.StarEqual, self.*.source[start .. current + 1], null, line, column)
                else
                    Token.init(.Star, self.*.source[start .. current + 1], null, line, column);
                try addToken(self, token);
            },
            '/' => {
                // Phân tích xem token này sẽ là /, /= hoặc //
                if (expectNextChar(self, '=')) {
                    const token: Token = Token.init(.SlashEqual, self.*.source[start .. current + 1], null, line, column);
                    try addToken(self, token);
                } else if (expectNextChar(self, '/')) {
                    moveCurrentToEndOfLine(self); // Tăng current đến cuôí hàng, lúc này vòng lặp mới sẽ tự bắt đầu
                } else {
                    const token: Token = Token.init(.Slash, self.*.source[start .. current + 1], null, line, column);
                    try addToken(self, token);
                }
            },
            '%' => {
                const token: Token = if (expectNextChar(self, '='))
                    Token.init(.PercentEqual, self.*.source[start .. current + 1], null, line, column)
                else
                    Token.init(.Percent, self.*.source[start .. current + 1], null, line, column);
                try addToken(self, token);
            },
            // Các trường hợp là các loại token khác như identifier keyword hoặc từ khoá
            else => {
                if (ascii.isAlphabetic(self.*.source[current])) {
                    // Trường hợp là chữ cái

                } else if (ascii.isAlphanumeric(self.*.source[current])) {
                    // trường hợp là chữ số
                } else {
                    // Các trường hợp khác
                    return LexecalError.UndefinedToken;
                }
            },
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
    column += 1; // Tăng giá trị column của token tiếp theo lên 1 đơn vị
}

// hàm chuyển nhanh biến đếm current đến ký tự xuống dòng gần nhất
fn moveCurrentToEndOfLine(self: *Self) void {
    // Tăng biến current cho đến khi gặp được ký tự xuống dòng
    while (!isAtEnd(self)) : (current += 1) {
        if (self.*.source[current] == '\n') {
            break;
        }
    }
}

// Hàm xác định xem alphabetic token có phải là một trong các keyword của lumin hay không
fn specifyAlphabeticToken(token_literal: []const u8) Token {
    // Kiểm tra xem có phải keyword hay không

    // `in`
    if (std.mem.eql(u8, token_literal, "in")) return Token.init(
        .In,
        token_literal,
        null,
        line,
        column,
    );

    // `func`
    if (std.mem.eql(u8, token_literal, "func")) return Token.init(
        .Func,
        token_literal,
        null,
        line,
        column,
    );

    // `if`
    if (std.mem.eql(u8, token_literal, "if")) return Token.init(
        .If,
        token_literal,
        null,
        line,
        column,
    );

    // `else`
    if (std.mem.eql(u8, token_literal, "else")) return Token.init(
        .Else,
        token_literal,
        null,
        line,
        column,
    );
}

// Báo cáo lỗi trong quá trình lexing (xuất ra dòng bị lỗi, chỉ ra cụ thể token đang bị lỗi)
// fn reportLexecalError() !void {
//     try stdout.
// }

// Error set cho các lỗi có thể xuất hiện trong quá trình scan token
pub const LexecalError: type = error{
    UndefinedToken, // Lỗi token không thể xác định
    IlligalCharacterLiteral, // Lỗi char literal không hợp lệ
    IllegalStringLiteral, // Lỗi string literal không hợp lệ
    IllegalNumberLiteral, // Lỗi number literal không hợp lệ
};

test "Lexer test" {
    const sample_source: []const u8 =
        \\+-*/%
        \\//[]
        \\++//--
    ;

    var lexer: Self = Self.init(std.testing.allocator, sample_source);
    defer lexer.deinit();
    try lexer.scanToken();

    for (lexer.tokens.items) |token| {
        try token.toString();
    }
}
