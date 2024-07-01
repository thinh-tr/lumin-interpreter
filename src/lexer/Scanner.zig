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
    var current_i: usize = 0; // Index của ký tự hiện tại
    var next_i: usize = current_i; // Index của ký tự tiếp theo

    var recently_added_token_len: usize = 0;

    while (current_i < source.len) {
        switch (source[current_i]) {
            '\n' => {
                current_line += 1;
                recently_added_token_len = 1;
            },

            '(' => {
                const new_token: Token = Token.init(TokenType.LEFT_PATEN, "(", current_line);
                tokens.append(new_token) catch |err| {
                    return err; // Trả ra Allocator.Error
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            ')' => {
                const new_token: Token = Token.init(TokenType.RIGHT_PATEN, ")", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            '{' => {
                const new_token: Token = Token.init(TokenType.LEFT_BRACE, "{", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            '}' => {
                const new_token: Token = Token.init(TokenType.RIGHT_BRACE, "}", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            ',' => {
                const new_token: Token = Token.init(TokenType.COMMA, ",", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            '.' => {
                const new_token: Token = Token.init(TokenType.DOT, ".", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            ':' => {
                const new_token: Token = Token.init(TokenType.COLON, ":", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            ';' => {
                const new_token: Token = Token.init(TokenType.SEMICOLON, ";", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            '[' => {
                const new_token: Token = Token.init(TokenType.LEFT_SQUARE_BRACKET, "[", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            ']' => {
                const new_token: Token = Token.init(TokenType.RIGHT_SQUARE_BRACKET, "]", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            // Kiểm tra các token có 1 đến 2 ký tự
            '+' => {
                next_i += 1;
                const new_token: Token = if (next_i <= source.len - 1 and source[next_i] == '=')
                    Token.init(TokenType.PLUS_EQUAL, "+=", current_line)
                else
                    Token.init(TokenType.PLUS, "+", current_line);

                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            '-' => {
                next_i += 1;
                const new_token: Token = if (next_i <= source.len - 1 and source[next_i] == '=')
                    Token.init(TokenType.MINUS_EQUAL, "-=", current_line)
                else
                    Token.init(TokenType.MINUS, "-", current_line);

                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            '*' => {
                next_i += 1;
                const new_token: Token = if (next_i <= source.len - 1 and source[next_i] == '=')
                    Token.init(TokenType.STAR_EQUAL, "*=", current_line)
                else
                    Token.init(TokenType.STAR, "*", current_line);

                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            '/' => {
                next_i += 1;
                const new_token: Token = if (next_i <= source.len - 1 and source[next_i] == '=')
                    Token.init(TokenType.SLASH_EQUAL, "/=", current_line)
                else
                    Token.init(TokenType.SLASH, "/", current_line);

                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            '%' => {
                next_i += 1;
                const new_token: Token = if (next_i <= source.len - 1 and source[next_i] == '=')
                    Token.init(TokenType.PERCENT_EQUAL, "%=", current_line)
                else
                    Token.init(TokenType.PERCENT, "%", current_line);

                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            '!' => {
                // Kiểm tra ký tự tiếp theo
                next_i += 1;
                const new_token: Token = if (next_i <= source.len - 1 and source[next_i] == '=')
                    Token.init(TokenType.BANG_EQUAL, "!=", current_line)
                else
                    Token.init(TokenType.BANG, "!", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            '=' => {
                // Kiểm tra ký tự tiếp theo
                next_i += 1;
                const new_token: Token = if (next_i <= source.len - 1 and source[next_i] == '=')
                    Token.init(TokenType.EQUAL_EQUAL, "==", current_line)
                else
                    Token.init(TokenType.EQUAL, "=", current_line);
                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },
            '>' => {
                next_i += 1;
                const new_token: Token = if (next_i <= source.len - 1 and source[next_i] == '=')
                    Token.init(TokenType.GREATER_EQUAL, ">=", current_line)
                else
                    Token.init(TokenType.GREATER, ">", current_line);

                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },
            '<' => {
                next_i += 1;
                const new_token: Token = if (next_i < source.len - 1 and source[next_i] == '=')
                    Token.init(TokenType.LESS_EQUAL, "<=", current_line)
                else
                    Token.init(TokenType.LESS, "<", current_line);

                tokens.append(new_token) catch |err| {
                    return err;
                };
                recently_added_token_len = new_token.lexeme.len;
            },

            // trường hợp không thể xác đinh được token đầu vào
            else => {
                return error.UnexpectedToken; // Trả ra lỗi không thể xác định được token
            },
        }
        // Cập nhật vị trí current_i và next_i
        current_i += recently_added_token_len;
        next_i = current_i;
    }
    return tokens;
}

test "testing scanTokens function" {
    const tokens: ArrayList(Token) = try scanTokens(
        \\!==
        \\===
        \\>==
        \\<==
        \\+==
        \\-==
        \\*==
        \\/==
        \\%==
        \\+-*/
    );

    defer tokens.deinit();

    std.debug.print("number of tokens: {}\n", .{tokens.items.len});

    for (tokens.items) |token| {
        std.debug.print("{s} - {} - {}\n", .{ token.lexeme, token.line, token.token_type});
    }
}
