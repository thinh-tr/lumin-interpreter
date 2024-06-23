pub const TokenType = enum {
    // Tokens một ký tự
    LEFT_PATEN, // `(`
    RIGHT_PATEN, // `)`

    LEFT_BRACE, // `{`
    RIGHT_BRACE,    // `}` 

    COMMA,  // `,`
    DOT, // `.`

    COLON,  // `:`
    SEMICOLON, // `;`

    PLUS, // `+`
    MINUS, // `-`
    STAR, // `*`
    SLASH, // `/`
    PERCENT,    // `%`


    // Token có từ 1 đến 2 ký tự
    BANG, // `!`
    BANG_EQUAL, // `!=`

    EQUAL, // `=`
    EQUAL_EQUAL, // `==`

    GREATER, // `>`
    GREATER_EQUAL, // `>=`

    LESS, // `<`
    LESS_EQUAL, // `<=`

    PLUS_EQUAL, // `+=`
    MINUS_EQUAL,    // `-=`
    STAR_EQUAL, // `*=`
    SLASH_EQUAL,    // `/=`
    PERCENT_EQUAL,  // `%=`

    AND_AND,    // `AND logic (&&)`
    VERDASH_VERDASH, // `OR logic (||)`


    // Literals
    IDENTIFIER, // Định danh
    STRING, // String literal
    NUMBER, // Number literal
    TYPE,   // Type literal


    // Từ khoá
    IN, // `in`
    FUNC,   // `function`
    IF, // `if`
    ELSE,   // `else`
    FOR,    // `for`
    WHILE,  // `while`
    DO, // `do`

    VAR,    // `var`
    CONST,  // `constant`

    THIS,   // `this`

    CLASS,  // `class`
    PROTOCOL,   // `protocol`
    STRUCT, // `struct`

    NULL,   // `null`
    TRUE,   // `true`
    FALSE,  // `false`

    RETURN, // `return`


    EOF
};