// TokenType enum (phân loại các kiểu token)
pub const TokenType: type = enum {
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
    STRUCT, // `struct`
    UNION, // `union`
    ERROR, // `error`
    ENUM, // `enum`
    NULL, // `null`
    TRUE, // `true`
    FALSE, // `false`
    RETURN, // `return`

    // Toán tử
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

    // Dấu phân tách (Delimeter)
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

    // Định danh (bắt đầu bằng chữ cái hoặc `_`)
    IDENTIFIER, // Định danh

    // Gía trị hằng số (Literal)
    STRING_LITERAL, // String literal
    CHAR_LITERAL, // Character literal
    INT_LITERAL, // Integer literal
    FLOAT_LITERAL, // Floating point literal

    // Chú thích
    SINGLELINE_COMMENT, // `//`
    MULTIPLELINE_COMMENT, // `/*...*/`

    // Tab và newline
    TAB, // `\t`
    NEWLINE, // `\n`

    EOF, // End Of File Token
};
