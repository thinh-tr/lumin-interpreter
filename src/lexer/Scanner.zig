const std = @import("std");
const page_allocator = std.heap.page_allocator;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const Token = @import("./Token.zig").Token;
const TokenType = @import("./TokenType.zig").TokenType;
const stdout = std.io.getStdOut().writer();
const ascii = std.ascii;

// Quét qua toàn bộ source code và trả ra các token trong đó
pub fn scanTokens(source: []const u8) !ArrayList(Token) {
    var tokens: ArrayList(Token) = ArrayList(Token).init(page_allocator);
    var current_i: usize = 0;   // Biến đếm xác định vị trí của ký tự hiện tại
    var added_token_length: usize = 0;  // Biến xác định đội dài của token vừa thêm
    var current_line: u128 = 1;
    // Vòng lặp kiểm tra
    while (current_i < source.len) : (current_i += added_token_length) {
        if (source[current_i] == '\n') {
            current_line += 1;
            added_token_length = 1;
            continue;   // Nhảy vòng lặp sang bước kế tiếp
        }

        // Lần lượt kiểm tra các ký tự
        switch (source[current_i]) {
            // `()`
            '(' => {
                try tokens.append(Token.init(TokenType.LEFT_PATEN, source[current_i..current_i + TokenType.LEFT_PATEN_LENGTH], current_line));
                added_token_length = TokenType.LEFT_PATEN_LENGTH;
            },
            ')' => {
                try tokens.append(Token.init(TokenType.RIGHT_PATEN, source[current_i..current_i + TokenType.RIGHT_PATEN_LENGTH], current_line));
                added_token_length = TokenType.RIGHT_PATEN_LENGTH;
            },

            // `{}`
            '{' => {
                try tokens.append(Token.init(TokenType.LEFT_BRACE, source[current_i..current_i + TokenType.LEFT_BRACE_LENGTH], current_line));
                added_token_length = TokenType.LEFT_BRACE_LENGTH;
            },
            '}' => {
                try tokens.append(Token.init(TokenType.RIGHT_BRACE, source[current_i..current_i + TokenType.RIGHT_BRACE_LENGTH], current_line));
                added_token_length = TokenType.RIGHT_BRACE_LENGTH;
            },

            // `,`
            ',' => {
                try tokens.append(Token.init(TokenType.COMMA, source[current_i..current_i + TokenType.COMMA_LENGTH], current_line));
                added_token_length = TokenType.COMMA_LENGTH;
            },

            // `.`
            '.' => {
                try tokens.append(Token.init(TokenType.DOT, source[current_i..current_i + TokenType.DOT_LENGTH], current_line));
                added_token_length = TokenType.DOT_LENGTH;
            },

            // `:`
            ':' => {
                try tokens.append(Token.init(TokenType.COLON, source[current_i..current_i + TokenType.COLON_LENGTH], current_line));
                added_token_length = TokenType.COLON_LENGTH;
            },

            // `;`
            ';' => {
                try tokens.append(Token.init(TokenType.SEMICOLON, source[current_i..current_i + TokenType.SEMICOLON_LENGTH], current_line));
                added_token_length = TokenType.SEMICOLON_LENGTH;
            },

            // `[]`
            '[' => {
                try tokens.append(Token.init(TokenType.LEFT_SQUARE_BRACKET, source[current_i..current_i + TokenType.LEFT_SQUARE_BRACKET_LENGTH], current_line));
                added_token_length = TokenType.LEFT_SQUARE_BRACKET_LENGTH;
            },
            ']' => {
                try tokens.append(Token.init(TokenType.RIGHT_SQUARE_BRACKET, source[current_i..current_i + TokenType.RIGHT_SQUARE_BRACKET_LENGTH], current_line));
                added_token_length = TokenType.RIGHT_SQUARE_BRACKET_LENGTH;
            },

            // `!` | `!=`
            '!' => {
                const token: Token = if (source[current_i..].len >= TokenType.BANG_EQUAL_LENGTH and source[current_i + 1] == '=')
                    Token.init(TokenType.BANG_EQUAL, source[current_i..current_i + TokenType.BANG_EQUAL_LENGTH], current_line)
                else
                    Token.init(TokenType.BANG, source[current_i..current_i + TokenType.BANG_LENGTH], current_line);
                try tokens.append(token);
                added_token_length = token.lexeme.len;
            },

            // `=` | `==`
            '=' => {
                const token: Token = if (source[current_i..].len >= TokenType.EQUAL_EQUAL_LENGTH and source[current_i + 1] == '=')
                    Token.init(TokenType.EQUAL_EQUAL, source[current_i..current_i + TokenType.EQUAL_EQUAL_LENGTH], current_line)
                else
                    Token.init(TokenType.EQUAL, source[current_i..current_i + TokenType.EQUAL_LENGTH], current_line);
                try tokens.append(token);
                added_token_length = token.lexeme.len;
            },

            // `>` | `>=`
            '>' => {
                const token: Token = if (source[current_i..].len >= TokenType.GREATER_EQUAL_LENGTH and source[current_i + 1] == '=')
                    Token.init(TokenType.GREATER_EQUAL, source[current_i..current_i + TokenType.GREATER_EQUAL_LENGTH], current_line)
                else
                    Token.init(TokenType.GREATER, source[current_i..current_i + TokenType.GREATER_LENGTH], current_line);
                try tokens.append(token);
                added_token_length = token.lexeme.len;
            },

            // `<` | `<=`
            '<' => {
                const token: Token = if (source[current_i..].len >= TokenType.LESS_EQUAL_LENGTH and source[current_i + 1] == '=')
                    Token.init(TokenType.LESS_EQUAL, source[current_i..current_i + TokenType.LESS_EQUAL_LENGTH], current_line)
                else
                    Token.init(TokenType.LESS, source[current_i..current_i + TokenType.LESS_LENGTH], current_line);
                try tokens.append(token);
                added_token_length = token.lexeme.len;
            },

            // `+` | `+=`
            '+' => {
                const token: Token = if (source[current_i..].len >= TokenType.PLUS_EQUAL_LENGTH and source[current_i + 1] == '=')
                    Token.init(TokenType.PLUS_EQUAL, source[current_i..current_i + TokenType.PLUS_EQUAL_LENGTH], current_line)
                else
                    Token.init(TokenType.PLUS, source[current_i..current_i + TokenType.PLUS_LENGTH], current_line);
                try tokens.append(token);
                added_token_length = token.lexeme.len;
            },

            // `-` | `-=`
            '-' => {
                const token = if (source[current_i..].len >= TokenType.MINUS_EQUAL_LENGTH and source[current_i + 1] == '=')
                    Token.init(TokenType.MINUS_EQUAL, source[current_i..current_i + TokenType.MINUS_EQUAL_LENGTH], current_line)
                else
                    Token.init(TokenType.MINUS, source[current_i..current_i + TokenType.MINUS_LENGTH], current_line);
                try tokens.append(token);
                added_token_length = token.lexeme.len;
            },

            // `*` | `*=`
            '*' => {
                const token: Token = if (source[current_i..].len >= TokenType.STAR_EQUAL_LENGTH and source[current_i + 1] == '=')
                    Token.init(TokenType.STAR_EQUAL, source[current_i..current_i + TokenType.STAR_EQUAL_LENGTH], current_line)
                else
                    Token.init(TokenType.STAR, source[current_i..current_i + TokenType.STAR_LENGTH], current_line);
                try tokens.append(token);
                added_token_length = token.lexeme.len;
            },

            // `/` | `/=`
            '/' => {
                const token: Token = if (source[current_i..].len >= TokenType.SLASH_EQUAL_LENGTH and source[current_i + 1] == '=')
                    Token.init(TokenType.SLASH_EQUAL, source[current_i..current_i + TokenType.SLASH_EQUAL_LENGTH], current_line)
                else
                    Token.init(TokenType.SLASH, source[current_i..current_i + TokenType.SLASH_LENGTH], current_line);
                try tokens.append(token);
                added_token_length = token.lexeme.len;
            },

            // `%` | `%=`
            '%' => {
                const token: Token = if (source[current_i..].len >= TokenType.PERCENT_EQUAL_LENGTH and source[current_i + 1] == '=')
                    Token.init(TokenType.PERCENT_EQUAL, source[current_i..current_i + TokenType.PERCENT_EQUAL_LENGTH], current_line)
                else
                    Token.init(TokenType.PERCENT, source[current_i..current_i + TokenType.PERCENT_LENGTH], current_line);
                try tokens.append(token);
                added_token_length = token.lexeme.len;
            },

            else => {
                try reportUnexpectedToken(source[current_i], current_line);
                return tokens;
            }
        }
    }

    return tokens;
}

// Hàm báo lỗi không thể xác định được token
fn reportUnexpectedToken(char: u8, line: u128) !void {
    try stdout.print("Unexpected token at line {}: `{c}`\n", .{line, char});
}

test "testing scanTokens function" {
    const tokens: ArrayList(Token) = try scanTokens(
        \\(){}
        \\,.
        \\:;
        \\[]
        \\!=!!=
        \\===
        \\>>=>
        \\<<=<
        \\++=+
        \\--=-
        \\**=*
        \\//=/
        \\%%=%
    );

    defer tokens.deinit();

    std.debug.print("number of tokens: {}\n", .{tokens.items.len});

    for (tokens.items) |token| {
        std.debug.print("token `{s}`, line: {}, type: {}\n", .{ token.lexeme, token.line, token.token_type});
    }
}
