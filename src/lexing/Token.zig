const TokenType = @import("./TokenType.zig").TokenType;

// Struct mô hình hoá thông tin Token
pub const Token = struct {
    token_type: TokenType,
    lexeme: []const u8,
    line: u128,

    const Self = @This();

    // Khởi tạo token
    pub fn init(token_type: TokenType, lexeme: []const u8, line: u128) Token {
        return Token{
            .token_type = token_type,
            .lexeme = lexeme,
            .line = line,
        };
    }
};
