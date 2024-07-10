const ArrayList = @import("std").ArrayList;

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
    TYPE_LITERAL, // Type literal

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


    // Độ dài của các từ khoá
    pub const IN_LENGTH: usize = 2; // `in`
    pub const FUNC_LENGTH: usize = 4; // `function`
    pub const IF_LENGTH: usize = 2; // `if`
    pub const ELSE_LENGTH: usize = 4; // `else`
    pub const FOR_LENGTH: usize = 3; // `for`
    pub const WHILE_LENGTH: usize = 5; // `while`
    pub const DO_LENGTH: usize = 2; // `do`

    pub const AND_LENGTH: usize = 3; // `And logic`
    pub const OR_LENGTH: usize = 2; // `Or logic`

    pub const VAR_LENGTH: usize = 3; // `var`
    pub const CONST_LENGTH: usize = 5; // `constant`

    pub const THIS_LENGTH: usize = 4; // `this`

    pub const CLASS_LENGTH: usize = 5; // `class`
    pub const PROTOCOL_LENGTH: usize = 8; // `protocol`
    pub const STRUCT_LENGTH: usize = 6; // `struct`
    pub const UNION_LENGTH: usize = 5; // `union`
    pub const ERROR_LENGTH: usize = 5; // `error`
    pub const ENUM_LENGTH: usize = 4; // `enum`

    pub const NULL_LENGTH: usize = 4; // `null`
    pub const TRUE_LENGTH: usize = 4; // `true`
    pub const FALSE_LENGTH: usize = 5; // `false`

    pub const RETURN_LENGTH: usize = 6; // `return`

    // Tất cả các hàm dưới đây đều bắt đầu kiểm tra từ ký tự thứ 2 trở đi cho mỗi trường hợp cần được xác định
    // Kiểm tra khi gặp ký tự `!`
    pub fn checkBANG_EQUAL(source: []const u8, position: usize) bool {
        if (position + 1 < source.len and source[position] == '=') return true;
        return false;
    }

    pub fn checkEQUAL_EQUAL(source: []const u8, position: usize) bool {
        if (position + 1 < source.len and source[position] == '=') return true;
        return false;
    }
};
