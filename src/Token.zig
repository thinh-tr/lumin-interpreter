const std = @import("std");
const stdout = std.io.getStdOut().writer();
const TokenType = @import("./TokenType.zig").TokenType;

const Self: type = @This(); // const self của kiểu Token

// Struct lưu thông tin Token
token_type: TokenType, // Loại token
lexeme: []const u8, // lexeme của token
literal_value: ?LiteralValue, // giá trị literal có thể có của token
line: u128, // vị trí dòng của token trong source code
column: u128, // vị trí cột bắt đầu của token

// Khởi tạo token
pub fn init(token_type: TokenType, lexeme: []const u8, literal_value: ?LiteralValue, line: u128, column: u128) Self {
    return Self{
        .token_type = token_type,
        .lexeme = lexeme,
        .literal_value = literal_value,
        .line = line,
        .column = column,
    };
}

pub fn toString(self: Self) !void {
    try stdout.print("Type: {any}, lexeme: \"{s}\", value: {any}, line: {d}, column: {d}\n", .{ self.token_type, self.lexeme, self.literal_value, self.line, self.column });
}

// Union type lưu thông tin Literal(chuỗi, số, ký tự,...) của một token nếu có
pub const LiteralValue: type = union {
    int: i128,
    float: f128,
    boolean: bool,
    string: []const u8,
    char: u8,
};