const std = @import("std");
const ArrayList = std.ArrayList;
const Token = @import("./Token.zig");
const TokenType = @import("./TokenType.zig").TokenType;
const Allocator = std.mem.Allocator;
const stdout = std.io.getStdOut().writer();
const ascii = std.ascii;
const StaticStringMap = std.StaticStringMap;

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
            ' ' => {},  // Không hành động đối với khoảng trắng
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
                } else if (expectNextChar(self, '*')) {
                    // Trường hợp gặp phải char bắt đầu của ghi chú nhiều dòng
                    try moveCurrentToCloseCommentCharsPair(self);   // di chuyển đến cặp ngoặc đóng comment, nếu không tìm thấy thì báo lỗi
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
                if (ascii.isAlphabetic(self.*.source[current]) or self.*.source[current] == '_') {
                    // Trường hợp là chữ cái hoặc dấu `_` -> duyệt literal đó cho đến khi gặp các char không phải chữ cái, gạch dưới `_` hoặc chữ số
                    while (!isAtEnd(self) and ascii.isAlphanumeric(self.*.source[current]) or self.*.source[current] == '_') {
                        current += 1;
                    }
                    // Lấy ra literal vừa duyệt
                    const literal: []const u8 = self.*.source[start .. current];
                    const token: Token = specifyAlphabeticToken(literal);
                    try addToken(self, token);
                    current -= 1;   // trừ current đi 1 để tránh làm mất token không phải Alphanumeric ở cuối dòng nếu có
                } else if (ascii.isAlphanumeric(self.*.source[current])) {
                    // trường hợp là chữ số
                } else {
                    // Các trường hợp khác
                    try reportLexecalError(self, "Undefined token");
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
            line += 1;  // Tăng số thứ tự dòng lên 1
            break;
        }
    }
}

// Hàm tìm và chuyển nhanh đến cặp ký tự đóng comment `*/`
fn moveCurrentToCloseCommentCharsPair(self: *Self) !void {
    while (!isAtEnd(self)) : (current += 1) {
        // Khi đã tìm thấy cặp ngoặc đóng
        if (self.*.source[current] == '*' and expectNextChar(self, '/')) {
            // Thoát vòng lặp nếu tìm ra cặp đấu đóng comment
            break;
        }
        // Khi tìm thấy ký tự xuống dòng -> reset lại line và column
        if (self.*.source[current] == '\n') {
            line += 1;
            column = 0;
        }
    } else {
        try reportLexecalError(self, "Unterminated comment");
        return LexecalError.UnterminatedComment;
    }
}

// Hàm xác định xem alphabetic token có phải là một trong các keyword của lumin hay không
fn specifyAlphabeticToken(literal: []const u8) Token {
    // Kiểm tra xem có phải keyword hay không bằng cách duyệt qua keyword map
    if (keywords_map.has(literal)) {
        // Trường hợp tìm thấy keyword trùng với literal này -> khởi tạo và thêm token chứa kiểu của literal
        return Token.init(keywords_map.get(literal).?, literal, null, line, column);
    } else {
        // Trường hợp không phải từ khoá thì tạo token định danh
        return Token.init(.Identifier, literal, null, line, column);
    }
}

// Báo cáo lỗi trong quá trình lexing (xuất ra dòng bị lỗi, chỉ ra cụ thể token đang bị lỗi)
fn reportLexecalError(self: *Self, message: []const u8) !void {
    try stdout.print("Error: {s}\n", .{message});
    try stdout.print("Line {}, column {}:\n", .{line, column});

    // Lấy ra dòng đang xét chứa token bị lỗi

    var b_index: usize = start; // backward index from start
    // Vòng lặp để lấy ra đoạn code ở phía trước ký tự ở vị trí start nếu start != 0
    while (b_index > 0 and self.*.source[b_index] != '\n') {
        b_index -= 1;   // biến đếm đi ngược cho đến khi gặp char `\n`
        // Nếu đã chạm đến ký tự xuống dòng
        if (self.*.source[b_index] == '\n') {
            b_index += 1;   // Trả lại vị trí phía sau để tránh lấy nhầm index ở ký tự `\n`
            break;
        }
    } 

    var f_index: usize = start; // forward index from start
    // Vòng lặp để lấy ra đoạn code ở phía sau ký tự ở vị trí start
    while (f_index < self.*.source.len and self.*.source[f_index] != '\n') {
        if (f_index == self.*.source.len) break;    // Thoát vòng lặp
        f_index += 1;
    }
    const current_line: []const u8 = self.*.source[b_index .. f_index];

    // Xuất ra line và chỉ ra vị trí bị lỗi trong line
    try stdout.print("\t{s}\n", .{current_line});
    try stdout.print("\t", .{});
    var pointed_error: bool = false;
    for (current_line) |char| {
        if (char == self.*.source[start] and !pointed_error) {
            try stdout.print("^", .{});
            pointed_error = true;
        } else {
            try stdout.print("~", .{});
        }
    }
    try stdout.print("\n", .{});
}

// Map chứa key - value của tất cả keyword trong lumin
const keywords_map: StaticStringMap(TokenType) = StaticStringMap(TokenType).initComptime(
    .{
        .{ "in", TokenType.In },
        .{ "func", TokenType.Func },
        .{ "if", TokenType.If },
        .{ "else", TokenType.Else },
        .{ "for", TokenType.For },
        .{ "while", TokenType.While },
        .{ "do", TokenType.Do },
        .{ "and", TokenType.And },
        .{ "or" , TokenType.Or },
        .{ "var", TokenType.Var },
        .{ "const", TokenType.Const },
        .{ "this", TokenType.This },
        .{ "struct", TokenType.Struct },
        .{ "union", TokenType.Union },
        .{ "error", TokenType.Error },
        .{ "enum", TokenType.Enum },
        .{ "null", TokenType.Null },
        .{ "true", TokenType.True },
        .{ "false", TokenType.False },
        .{ "return", TokenType.Return },
        .{ "throw", TokenType.Throw },
    }
);

// Error set cho các lỗi có thể xuất hiện trong quá trình scan token
pub const LexecalError: type = error{
    UndefinedToken, // Lỗi token không thể xác định
    IlligalCharacterLiteral, // Lỗi char literal không hợp lệ
    IllegalStringLiteral, // Lỗi string literal không hợp lệ
    IllegalNumberLiteral, // Lỗi number literal không hợp lệ
    UnterminatedComment, // Lỗi comment nhiều dòng chưa được đóng /*...*/
};

test "Lexer test" {
    const sample_source: []const u8 =
        \\var a;
        \\func getData();@
    ;

    var lexer: Self = Self.init(std.testing.allocator, sample_source);
    defer lexer.deinit();
    try lexer.scanToken();

    for (lexer.tokens.items) |token| {
        try token.toString();
    }

}
