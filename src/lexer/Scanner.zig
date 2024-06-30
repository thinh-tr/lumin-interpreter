const std = @import("std");
const page_allocator = std.heap.page_allocator;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const Token = @import("./Token.zig").Token;
const TokenType = @import("./TokenType.zig").TokenType;

// Quét qua toàn bộ source code và trả ra các token trong đó
pub fn scanTokens(source: []const u8) !ArrayList(Token) {
    var tokens: ArrayList(Token) = ArrayList(Token).init(page_allocator);

    var current_line: i128 = 1; // Xác định dòng hiện tại
    var current_i: usize = 0;   // Index của ký tự hiện tại
    var next_i: usize = current_i;  // Index của ký tự tiếp theo

    while (current_i < source.len) {
        switch (source[current_i]) {
            '\n' => {
                current_line += 1;
                // current_i += 1;
                // next_i = current_i;
            },
            '(' => {
                tokens.append(Token.init(TokenType.LEFT_PATEN, "(", current_line)) catch |err| {
                    return err; // Trả ra Allocator.Error
                };
            },
            ')' => {
                tokens.append(Token.init(TokenType.RIGHT_PATEN, ")", current_line)) catch |err| {
                    return err;
                };
            },
            '{' => {
                tokens.append(Token.init(TokenType.LEFT_BRACE, "{", current_line)) catch |err| {
                    return err;
                };
            },
            '}' => {
                tokens.append(Token.init(TokenType.RIGHT_BRACE, "}", current_line)) catch |err| {
                    return err;
                };
            },
            ',' => {
                tokens.append(Token.init(TokenType.COMMA, ",", current_line)) catch |err| {
                    return err;
                };
            },
            '.' => {
                tokens.append(Token.init(TokenType.DOT, ".", current_line)) catch |err| {
                    return err;
                };
            },
            ':' => {
                tokens.append(Token.init(TokenType.COLON, ":", current_line)) catch |err| {
                    return err;
                };
            },
            ';' => {
                tokens.append(Token.init(TokenType.SEMICOLON, ";", current_line)) catch |err| {
                    return err;
                };
            },
            '+' => {
                tokens.append(Token.init(TokenType.PLUS, "+", current_line)) catch |err| {
                    return err;
                };
            },
            '-' => {
                tokens.append(Token.init(TokenType.MINUS, "-", current_line)) catch |err| {
                    return err;
                };
            },
            '*' => {
                tokens.append(Token.init(TokenType.STAR, "*", current_line)) catch |err| {
                    return err;
                };
            },
            '/' => {
                tokens.append(Token.init(TokenType.SLASH, "/", current_line)) catch |err| {
                    return err;
                };
            },
            '%' => {
                tokens.append(Token.init(TokenType.PERCENT, "%", current_line)) catch |err| {
                    return err;
                };
            },
            '[' => {
                tokens.append(Token.init(TokenType.LEFT_SQUARE_BRACKET, "[", current_line)) catch |err| {
                    return err;
                };
            },
            ']' => {
                tokens.append(Token.init(TokenType.RIGHT_SQUARE_BRACKET, "]", current_line)) catch |err| {
                    return err;
                };
            },
            else => {
                return error.UnexpectedToken;   // Trả ra lỗi không thể xác định được token
            },
        }
        current_i += 1;
        next_i = current_i;
    }
    return tokens;
}

test "testing scanTokens function" {
    const tokens: ArrayList(Token) = try scanTokens(
        \\(((((
        \\(((((
        \\+-*/
        \\[][](())
        \\////**%+
        \\$
    );

    defer tokens.deinit();

    for (tokens.items) |token| {
        std.debug.print("{s} - {}\n", .{token.lexeme, token.line});
    }
}