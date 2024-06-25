const std = @import("std");
const TokenType = @import("./TokenType.zig").TokenType;

// Struct chứa thông tin Token
pub const Token = struct {
    token_type: TokenType,
    lexeme: []u8,
    line: i128,

    const Self = @This();

    // Khởi tạo token
    pub fn init(token_type: TokenType, lexeme: []u8, line: i128) Token {
        return Token{
            .token_type = token_type,
            .lexeme = lexeme,
            .line = line,
        };
    }

    pub fn toString(self: *Self) ![]u8 {
        return try std.fmt.allocPrint(std.heap.page_allocator, "type: {s} - lexeme: {s}\n", .{self.*.token_type, self.*.lexeme});
    }
};