const TokenType = @import("./token_type.zig").TokenType;

// Struct lưu thông tin Token
pub const Token: type = struct {
    token_type: TokenType,  // Loại token
    lexeme: []const u8, // lexeme của token
    literal_value: ?LiteralValue,  // giá trị literal có thể có của token
    line: u128, // vị trí dòng của token trong source code
    column: u128,    // vị trí cột bắt đầu của token

    // Khởi tạo token
    pub fn init(token_type: TokenType, lexeme: []const u8, literal_value: ?LiteralValue, line: u128, column: u128) Token {
        return Token{
            .token_type = token_type,
            .lexeme = lexeme,
            .literal_value = literal_value,
            .line = line,
            .column = column,
        }; 
    }
};

// Union type lưu thông tin Literal(chuỗi, số, ký tự,...) của một token nếu có
pub const LiteralValue: type = union {
    int: i128,
    float: f128,
    boolean: bool,
    str: []const u8,
    char: u8,
};