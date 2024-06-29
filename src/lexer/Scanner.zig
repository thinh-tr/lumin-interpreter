const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Token = @import("./Token.zig").Token;
const TokenType = @import("./TokenType.zig").TokenType;
const page_allocator = std.heap.page_allocator;
const reportError = @import("../main.zig").reportError;

pub const Scanner = struct {
    // Hàm scan toàn bộ source code thành Token và thêm vào token list
    pub fn scanTokens(source: []const u8) Allocator.Error!ArrayList(Token) {
        var token_list: ArrayList(Token) = ArrayList(Token).init(page_allocator);
        //defer token_list.deinit();

        // Biến xác định vị trí dòng hiện tại
        var current_line: i128 = 1; // Tính từ dòng thứ 1

        // Biến đếm xác định vị trí của char đang xét và char kế cận
        var current_i: usize = 0; // Xét từ index 0
        var next_i: usize = current_i; // Biến đếm cho vị trí kế cận với current_i

        // Vòng lặp quét từ ký tự đầu tiên đến ký tự cuối cùng
        while (current_i < source.len) {
            if (source[current_i] == '\n') current_line += 1; // Nếu là ký tự xuống dòng thì tăng current line lên 1

            // Đầu tiên sẽ kiểm tra các Token chỉ có 1 ký tự
            if (source[current_i] == '(') {
                try token_list.append(Token.init(TokenType.LEFT_PATEN, "(", current_line));
            } else if (source[current_i] == ')') {
                try token_list.append(Token.init(TokenType.RIGHT_PATEN, ")", current_line));
            } else if (source[current_i] == '{') {
                try token_list.append(Token.init(TokenType.LEFT_BRACE, "{", current_line));
            } else if (source[current_i] == '}') {
                try token_list.append(Token.init(TokenType.RIGHT_BRACE, "}", current_line));
            } else if (source[current_i] == '[') {
                try token_list.append(Token.init(TokenType.LEFT_SQUARE_BRACKET, "[", current_line));
            } else if (source[current_i] == ']') {
                try token_list.append(Token.init(TokenType.RIGHT_SQUARE_BRACKET, "]", current_line));
            } else if (source[current_i] == ',') {
                try token_list.append(Token.init(TokenType.COMMA, ",", current_line));
            } else if (source[current_i] == '.') {
                try token_list.append(Token.init(TokenType.DOT, ".", current_line));
            } else if (source[current_i] == ':') {
                try token_list.append(Token.init(TokenType.COLON, ":", current_line));
            } else if (source[current_i] == ';') {
                try token_list.append(Token.init(TokenType.SEMICOLON, ";", current_line));
            } else if (source[current_i] == '+') {
                try token_list.append(Token.init(TokenType.PLUS, "+", current_line));
            } else if (source[current_i] == '-') {
                try token_list.append(Token.init(TokenType.MINUS, "-", current_line));
            } else if (source[current_i] == '*') {
                try token_list.append(Token.init(TokenType.STAR, "*", current_line));
            } else if (source[current_i] == '/') {
                try token_list.append(Token.init(TokenType.SLASH, "/", current_line));
            } else if (source[current_i] == '%') {
                try token_list.append(Token.init(TokenType.PERCENT, "%", current_line));
            }

            current_i += 1; // Tăng vị trí hiện tại lên 1
            next_i = current_i;
        }

        return token_list; // trả ra token list
    }

    // Hàm thêm token vào token list được chỉ định
};




// Test cases

test "scan token checking" {
    const tokens = try Scanner.scanTokens(
        \\+, -, *, /
        \\{}[]//
    );

    for (tokens.items) |token| {
        std.debug.print("lexeme: {s} - line: {}\n", .{token.lexeme, token.line});
    }
}
