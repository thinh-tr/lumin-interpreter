const std = @import("std");
const ArrayList = std.ArrayList;
const Token = @import("./token.zig").Token;
const TokenType = @import("./token.zig").TokenType;
const TokenValue = @import("./token.zig").TokenValue;
const Allocator = std.mem.Allocator;
const stdout = std.io.getStdOut().writer();
const ascii = std.ascii;
const LexicalError = @import("./token.zig").LexicalError;
const KeywordMap = @import("./token.zig").KeywordMap;

const Self: type = @This(); // Tham chiếu đến kiểu Lexer

// Struct chứa chức năng Lexer
source: []const u8, // Trường chứa chuỗi mã nguồn cần scan
tokens: ArrayList(Token), // List chứa token đã được scan

var pos: usize = 0; // vị trí đang xét
var line: u128 = 1; // Vị trí dòng của lexeme đang xét
var column: u128 = 0; // Vị trí column của token đang xét

// Biến lấy vị trí của ký tự đầu tiên mỗi lần đến một dòng mới -> Giúp hàm thông báo xuất ra dòng bị lỗi
var start_of_line_pos: usize = 0;

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

// Hàm lấy ra ký tự ở vị trí hiện tại và tiến đến vị trí tiếp theo (hàm này đẩy pos tiến về phía trước)
fn nextChar(self: *Self) ?u8 {
    if (pos >= self.*.source.len) return null;  // Trả ra null nếu đã không còn char nào để xét
    const char: u8 = self.*.source[pos];
    pos += 1;   // Tăng pos lên 1
    return char;
}

// Hàm lấy ra char ở pos hiện tại
fn expectNextChar(self: *Self, expected_char: u8) bool {
    if (pos >= self.*.source.len) return false; // Trả ra false nếu đã vượt ra ngoài source
    if (self.*.source[pos] == expected_char) {
        pos += 1;   // Tăng pos lên 1
        return true;
    } else {
        return false;
    }
}

// Hàm thêm token
fn addToken(self: *Self, token: Token) !void {
    try self.*.tokens.append(token);
    column += 1;
}

// Hàm báo lỗi khi phát hiện token không hợp lệ
fn reportLexicalError(self: *Self, lexical_error: LexicalError) !void {
    // Thông báo lỗi    
    // Lấy ra vị trí cuối cùng của line chứa token bị lỗi
    var end_of_line_pos: usize = pos; // set bằng với vị trí hiện tại
    while (end_of_line_pos < self.*.source.len and self.*.source[end_of_line_pos] != '\n') {
        end_of_line_pos += 1;
    }
    const err_source_line: []const u8 = self.*.source[start_of_line_pos..end_of_line_pos];

    try stdout.print("Error line {}:{} -> {!}\n", .{line, column, lexical_error});
    try stdout.print("\t{s}\n\t", .{err_source_line});
    for (start_of_line_pos..end_of_line_pos) |i| {
        const pos_of_current_char: usize = pos - 1; // Trừ 1 để tránh việc hiển thị con trỏ bị lệch vì pos đã ở vị trí tiếp theo :)
        if (pos_of_current_char == i) {
            try stdout.print("^", .{});
        } else {
            try stdout.print(" ", .{});
        }
    }
    try stdout.print("\n", .{});
}

// Hàm lex các Token bao gồm các ký tự và dấu phân tách
fn lexCharacterToken(self: *Self, char: u8) ?Token {
    switch (char) {
        // Singel char token
        '(' => {
            return Token.init(TokenType.LeftPaten, null, line, column);
        },
        ')' => {
            return Token.init(TokenType.RightPaten, null, line, column);
        },
        '{' => {
            return Token.init(TokenType.LeftBrace, null, line, column);
        },
        '}' => {
            return Token.init(TokenType.RightBrace, null, line, column);
        },
        ',' => {
            return Token.init(TokenType.Comma, null, line, column);
        },
        '.' => {
            return Token.init(TokenType.Dot, null, line, column);
        },
        ':' => {
            return Token.init(TokenType.Colon, null, line, column);
        },
        ';' => {
            return Token.init(TokenType.Semicolon, null, line, column);
        },
        '[' => {
            return Token.init(TokenType.LeftSquareBracket, null, line, column);
        },
        ']' => {
            return Token.init(TokenType.RightSquareBracket, null, line, column);
        },

        // Operator token
        '^' => {
            return Token.init(TokenType.Circumflex, null, line, column);
        },
        '!' => {
            if (expectNextChar(self, '=')) {
                return Token.init(TokenType.BangEqual, null, line, column);
            }
            return Token.init(TokenType.Bang, null, line, column);
        },
        '=' => {
            if (expectNextChar(self, '=')) {
                return Token.init(TokenType.EqualEqual, null, line, column);
            }
            if (expectNextChar(self, '>')) {
                return Token.init(TokenType.LambdaArrow, null, line, column);
            }
            return Token.init(TokenType.Equal, null, line, column);
        },
        '>' => {
            if (expectNextChar(self, '=')) {
                return Token.init(TokenType.GreaterEqual, null, line, column);
            }
            return Token.init(TokenType.Greater, null, line, column);
        },
        '<' => {
            if (expectNextChar(self, '=')) {
                return Token.init(TokenType.LesserEqual, null, line, column);
            }
            return Token.init(TokenType.Lesser, null, line, column);
        },
        '+' => {
            if (expectNextChar(self, '=')) {
                return Token.init(TokenType.PlusEqual, null, line, column);
            }
            return Token.init(TokenType.Plus, null, line, column);
        },
        '-' => {
            if (expectNextChar(self, '=')) {
                return Token.init(TokenType.MinusEqual, null, line, column);
            }
            return Token.init(TokenType.Minus, null, line, column);
        },
        '*' => {
            if (expectNextChar(self, '=')) {
                return Token.init(TokenType.StarEqual, null, line, column);
            }
            return Token.init(TokenType.Star, null, line, column);
        },
        '/' => {
            if (expectNextChar(self, '=')) {
                return Token.init(TokenType.SlashEqual, null, line, column);
            }
            return Token.init(TokenType.Slash, null, line, column);
        },
        '%' => {
            if (expectNextChar(self, '=')) {
                return Token.init(TokenType.PercentEqual, null, line, column);
            }
            return Token.init(TokenType.Percent, null, line, column);
        },

        else => {
            return null;    // Trả ra null nếu không thể nhận ra token
        }
    }
}

// Hàm lex các token bắt đầu bằng chữ cái
fn lexAlphabeticToken(self: *Self) Token {
    // Nếu gặp phải ký tự thuộc bản chữ cái thì sẽ xét tất cả các ký tự Alphanumeric liền kề còn lại để tạo thành Token
    const start_pos: usize = pos - 1;   // vị trí bắt đầu của token này pos - 1 là vị trí của char đang xét
    while (pos < self.*.source.len and ascii.isAlphanumeric(self.*.source[pos]) or self.*.source[pos] == '_') {
        pos += 1;
    }
    const token_lexeme: []const u8 = self.*.source[start_pos..pos];  // pos - 1 là vị trí của char đang xét

    // Kiểm tra xem token tìm được có phải là từ khoá hay không
    if (KeywordMap.has(token_lexeme)) {
        if (std.mem.eql(u8, token_lexeme, "true")) { 
            // Trả ra token với giá trị True
            return Token.init(TokenType.True, TokenValue{.Bool = true}, line, column);
        }
        if (std.mem.eql(u8, token_lexeme, "false")) {
            // Trả ra token với giá trị false
            return Token.init(TokenType.False, TokenValue{.Bool = false}, line, column);
        }
        return Token.init(KeywordMap.get(token_lexeme).?, null, line, column);    // Trả ra token chứa keyword tìm được
    }
    return Token.init(TokenType.Identifier, TokenValue{.String = token_lexeme}, line, column);
}

// Hàm scan tuyến tính source từ đầu đến cuối
fn lexToken(self: *Self) !void {
    // Vòng lặp này tự thoát khi nextChar trả ra null -> đã đến cuối source
    while (nextChar(self)) |char| {
        if (char == ' ') continue;  // Lặp lại vòng lặp nếu gặp khoảng trắng
        if (char == '\n') { // Nếu gặp phải chr xuống dòng
            line += 1;  // tăng line lên 1
            column = 0; // reset column về 0
            start_of_line_pos = pos;
        } else if (ascii.isAlphabetic(char) or char == '_') {
            // Trường hợp char là chữ cái hoặc dấu gạch dưới -> keyword, identifier
            try addToken(self, lexAlphabeticToken(self));
        } else if (ascii.isDigit(char)) {
            // Trường hợp char là chữ số -> number lexeme

        } else {
            // Các trường hợp còn lại -> Delimeter, ký tự đặc biệt,...
            if (lexCharacterToken(self, char)) |token| {
                // Thêm Token vào list
                try addToken(self, token);
            } else {
                try reportLexicalError(self, LexicalError.UndefinedToken);
                return LexicalError.UndefinedToken;  // Trả ra error nếu không nhận diện được ký tự
            }
        }
    }
}

test "Lexer test" {
    const source: []const u8 = 
        \\var boolValue: bool = true;
    ;
    var lexer = Self.init(std.heap.page_allocator, source);
    defer lexer.deinit();
    try lexer.lexToken();
    for (lexer.tokens.items) |*token| {
        //std.debug.print("{any}\n", .{token});
        token.*.toString();
    }
    //try std.testing.expect(lexer.tokens.items.len == 17);
}