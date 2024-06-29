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

    LEFT_SQUARE_BRACKET,    // `[`
    RIGHT_SQUARE_BRACKET,   // `]`


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


    // Literals
    IDENTIFIER, // Định danh
    STRING_LITERAL, // String literal
    CHAR_LITERAL,   // Character literal
    NUMBER_LITERAL, // Number literal
    TYPE_LITERAL,   // Type literal


    // Từ khoá
    IN, // `in`
    FUNC,   // `function`
    IF, // `if`
    ELSE,   // `else`
    FOR,    // `for`
    WHILE,  // `while`
    DO, // `do`

    AND,    // `And logic`
    OR, // `Or logic`

    VAR,    // `var`
    CONST,  // `constant`

    THIS,   // `this`

    CLASS,  // `class`
    PROTOCOL,   // `protocol`
    STRUCT, // `struct`
    UNION,  // `union`
    ERROR,  // `error`
    ENUM,   // `enum`

    NULL,   // `null`
    TRUE,   // `true`
    FALSE,  // `false`

    RETURN, // `return`


    EOF
};