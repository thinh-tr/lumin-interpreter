const std = @import("std");

pub const TokenType = enum {
    // Tokens một ký tự
    LEFT_PATEN, // `(`
    RIGHT_PATEN, // `)`

    LEFT_BRACE, // `{`
    RIGHT_BRACE, // `}`

    COMMA, // `,`
    DOT, // `.`

    COLON, // `:`
    SEMICOLON, // `;`

    LEFT_SQUARE_BRACKET, // `[`
    RIGHT_SQUARE_BRACKET, // `]`

    // Token có từ 1 đến 2 ký tự
    BANG, // `!`
    BANG_EQUAL, // `!=`

    EQUAL, // `=`
    EQUAL_EQUAL, // `==`

    GREATER, // `>`
    GREATER_EQUAL, // `>=`

    LESS, // `<`
    LESS_EQUAL, // `<=`

    PLUS, // `+`
    MINUS, // `-`
    STAR, // `*`
    SLASH, // `/`
    PERCENT, // `%`
    PLUS_EQUAL, // `+=`
    MINUS_EQUAL, // `-=`
    STAR_EQUAL, // `*=`
    SLASH_EQUAL, // `/=`
    PERCENT_EQUAL, // `%=`

    // Literals
    IDENTIFIER, // Định danh
    STRING_LITERAL, // String literal
    CHAR_LITERAL, // Character literal
    NUMBER_LITERAL, // Number literal

    // Từ khoá
    IN, // `in`
    FUNC, // `function`
    IF, // `if`
    ELSE, // `else`
    FOR, // `for`
    WHILE, // `while`
    DO, // `do`

    AND, // `And logic`
    OR, // `Or logic`

    VAR, // `var`
    CONST, // `constant`

    THIS, // `this`

    CLASS, // `class`
    PROTOCOL, // `protocol`
    STRUCT, // `struct`
    UNION, // `union`
    ERROR, // `error`
    ENUM, // `enum`

    NULL, // `null`
    TRUE, // `true`
    FALSE, // `false`

    RETURN, // `return`

    // Độ dài của các token 1 ký tự
    pub const LEFT_PATEN_LENGTH: usize = 1;
    pub const RIGHT_PATEN_LENGTH: usize = 1;
    pub const LEFT_BRACE_LENGTH: usize = 1;
    pub const RIGHT_BRACE_LENGTH: usize = 1;
    pub const COMMA_LENGTH: usize = 1;
    pub const DOT_LENGTH: usize = 1;
    pub const COLON_LENGTH: usize = 1;
    pub const SEMICOLON_LENGTH: usize = 1;
    pub const LEFT_SQUARE_BRACKET_LENGTH: usize = 1;
    pub const RIGHT_SQUARE_BRACKET_LENGTH: usize = 1;

    // Độ dài của các token có từ 1 đến 2 lý tự
    pub const BANG_LENGTH: usize = 1; // `!`
    pub const BANG_EQUAL_LENGTH: usize = 2; // `!=`

    pub const EQUAL_LENGTH: usize = 1; // `=`
    pub const EQUAL_EQUAL_LENGTH: usize = 2; // `==`

    pub const GREATER_LENGTH: usize = 1; // `>`
    pub const GREATER_EQUAL_LENGTH: usize = 2; // `>=`

    pub const LESS_LENGTH: usize = 1; // `<`
    pub const LESS_EQUAL_LENGTH: usize = 2; // `<=`

    pub const PLUS_LENGTH: usize = 1; // `+`
    pub const MINUS_LENGTH: usize = 1; // `-`
    pub const STAR_LENGTH: usize = 1; // `*`
    pub const SLASH_LENGTH: usize = 1; // `/`
    pub const PERCENT_LENGTH: usize = 1; // `%`
    pub const PLUS_EQUAL_LENGTH: usize = 2; // `+=`
    pub const MINUS_EQUAL_LENGTH: usize = 2; // `-=`
    pub const STAR_EQUAL_LENGTH: usize = 2; // `*=`
    pub const SLASH_EQUAL_LENGTH: usize = 2; // `/=`
    pub const PERCENT_EQUAL_LENGTH: usize = 2; // `%=`

    // Hàm kiểm tra nếu Token là keyword
    pub fn defineTypeOfAlphabeticToken(literal: []const u8) TokenType {
        if (std.mem.eql(u8, literal, "in")) {
            return TokenType.IN;
        } else if (std.mem.eql(u8, literal, "func")) {
            return TokenType.FUNC;
        } else if (std.mem.eql(u8, literal, "if")) {
            return TokenType.IF;
        } else if (std.mem.eql(u8, literal, "else")) {
            return TokenType.ELSE;
        } else if (std.mem.eql(u8, literal, "for")) {
            return TokenType.FOR;
        } else if (std.mem.eql(u8, literal, "while")) {
            return TokenType.WHILE;
        } else if (std.mem.eql(u8, literal, "do")) {
            return TokenType.DO;
        } else if (std.mem.eql(u8, literal, "and")) {
            return TokenType.AND;
        } else if (std.mem.eql(u8, literal, "or")) {
            return TokenType.OR;
        } else if (std.mem.eql(u8, literal, "var")) {
            return TokenType.VAR;
        } else if (std.mem.eql(u8, literal, "const")) {
            return TokenType.CONST;
        } else if (std.mem.eql(u8, literal, "this")) {
            return TokenType.THIS;
        } else if (std.mem.eql(u8, literal, "class")) {
            return TokenType.CLASS;
        } else if (std.mem.eql(u8, literal, "protocol")) {
            return TokenType.PROTOCOL;
        } else if (std.mem.eql(u8, literal, "struct")) {
            return TokenType.STRUCT;
        } else if (std.mem.eql(u8, literal, "union")) {
            return TokenType.UNION;
        } else if (std.mem.eql(u8, literal, "error")) {
            return TokenType.ERROR;
        } else if (std.mem.eql(u8, literal, "enum")) {
            return TokenType.ENUM;
        } else if (std.mem.eql(u8, literal, "null")) {
            return TokenType.NULL;
        } else if (std.mem.eql(u8, literal, "true")) {
            return TokenType.TRUE;
        } else if (std.mem.eql(u8, literal, "false")) {
            return TokenType.FALSE;
        } else if (std.mem.eql(u8, literal, "return")) {
            return TokenType.RETURN;
        } else {
            // Nếu literal không phải bất kỳ từ khoá nào thì sẽ được xác định là indentifier
            return TokenType.IDENTIFIER;
        }
    }
};
