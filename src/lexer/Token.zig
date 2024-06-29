const std = @import("std");
const TokenType = @import("./TokenType.zig").TokenType;
const stdout = std.io.getStdOut().writer();

// Struct chứa thông tin Token
pub const Token = struct {
    token_type: TokenType,
    lexeme: []const u8,
    line: i128,

    const Self = @This();

    // Khởi tạo token
    pub fn init(token_type: TokenType, lexeme: []const u8, line: i128) Token {
        return Token{
            .token_type = token_type,
            .lexeme = lexeme,
            .line = line,
        };
    }

    pub fn printInfo(self: *Self) !void {
        try stdout.print("Token type: {any}, lexeme: {s}, line: {}\n", .{self.*.token_type, self.*.lexeme, self.*.line});
    }
};