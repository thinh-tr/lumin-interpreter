// TokenType enum (phân loại các kiểu token)
pub const TokenType = enum {
    // Từ khoá
    In, // `in`
    Func, // `function`
    If, // `if`
    Else, // `else`
    For, // `for`
    While, // `while`
    Do, // `do`
    And, // `And logic`
    Or, // `Or logic`
    Var, // `var`
    Const, // `constant`
    This, // `this`
    Struct, // `struct`
    Union, // `union`
    Error, // `error`
    Enum, // `enum`
    Null, // `null`
    True, // `true`
    False, // `false`
    Return, // `return`
    ReturnError,    // 'return!'

    // Toán tử
    Circumflex, // `^` (toán tử dành cho số mũ)
    Bang, // `!`
    BangEqual, // `!=`
    Equal, // `=`
    EqualEqual, // `==`
    Greater, // `>`
    GreaterEqual, // `>=`
    Lesser, // `<`
    LesserEqual, // `<=`
    Plus, // `+`
    PlusEqual, // `+=`
    Minus, // `-`
    MinusEqual, // `-=`
    Star, // `*`
    StarEqual, // `*=`
    Slash, // `/`
    SlashEqual, // `/=`
    Percent, // `%`
    PercentEqual, // `%=`

    // Dấu phân tách (Delimeter)
    LeftPaten, // `(`
    RightPaten, // `)`
    LeftBrace, // `{`
    RightBrace, // `}`
    Comma, // `,`
    Dot, // `.`
    Colon, // `:`
    Semicolon, // `;`
    LeftSquareBracket, // `[`
    RightSquareBracket, // `]`

    // Định danh (bắt đầu bằng chữ cái hoặc `_`)
    Identifier, // Định danh

    // Gía trị hằng số (Literal)
    StringLiteral, // String literal
    CharLiteral, // Character literal
    IntLiteral, // Integer literal
    FloatLiteral, // Floating point literal

    // Chú thích
    SinglelineComment, // `//`
    MultiplelineComment, // `/*...*/`

    // Tab và newline
    Tab, // `\t`
    Newline, // `\n`
};