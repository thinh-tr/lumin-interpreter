const std = @import("std");
const ArrayList = std.ArrayList;
const Token = @import("./token.zig").Token;
const TokenType = @import("./token.zig").TokenType;
const Allocator = std.mem.Allocator;
const stdout = std.io.getStdOut().writer();
const ascii = std.ascii;
const LexingError = @import("./token.zig").LexingError;

const Self: type = @This(); // Tham chiếu đến kiểu Lexer

// Struct chứa chức năng Lexer
source: []const u8, // Trường chứa chuỗi mã nguồn cần scan
tokens: ArrayList(Token), // List chứa token đã được scan

var pos: usize = 0; // vị trí đang xét
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

// Hàm lấy ra ký tự ở vị trí hiện tại và tiến đến vị trí tiếp theo (hàm này đẩy pos tiến về phía trước)
fn nextChar(self: *Self) ?u8 {
    if (pos >= self.*.source.len) return null;  // Trả ra null nếu đã không còn char nào để xét
    const char: u8 = self.*.source[pos];
    pos += 1;   // Tăng pos lên 1
    return char;
}

// Hàm lấy ra char ở pos hiện tại
fn peekChar(self: *Self) ?u8 {
    if (pos >= self.*.source.len) return null;
    const char: u8 = self.*.source[pos];
    pos += 1;   // Tăng pos lên 1
    return char;
}

// Hàm thêm token
fn addToken(self: *Self, token: Token) !void {
    try self.*.tokens.append(token);
    column += 1;
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
            if (peekChar(self) == '=') {
                return Token.init(TokenType.BangEqual, null, line, column);
            }
            return Token.init(TokenType.Bang, null, line, column);
        },
        '=' => {
            if (peekChar(self) == '=') {
                return Token.init(TokenType.EqualEqual, null, line, column);
            }
            return Token.init(TokenType.Equal, null, line, column);
        },

        else => {
            return null;    // Trả ra null nếu không thể nhận ra token
        }
    }
}

// Hàm scan tuyến tính source từ đầu đến cuối
fn lexToken(self: *Self) !void {
    // Vòng lặp này tự thoát khi nextChar trả ra null -> đã đến cuối source
    while (nextChar(self)) |char| {
        // Nếu gặp phải chr xuống dòng
        if (char == '\n') {
            line += 1;  // tăng line lên 1
            column = 0; // reset column về 0
        } else if (ascii.isAlphabetic(char)) {
            // Trường hợp char là chữ cái -> keyword, identifier

        } else if (ascii.isDigit(char)) {
            // Trường hợp char là chữ số -> number lexeme

        } else {
            // Các trường hợp còn lại -> Delimeter, ký tự đặc biệt,...
            if (lexCharacterToken(self, char)) |token| {
                // Thêm Token vào list
                try addToken(self, token);
            }
        }
    }
}

test "Lexer test" {
    const source: []const u8 = 
        \\;
        \\;;
    ;
    var lexer = Self.init(std.heap.page_allocator, source);
    defer lexer.deinit();
    try lexer.lexToken();
    std.debug.print("{any}", .{lexer.tokens.items});
}