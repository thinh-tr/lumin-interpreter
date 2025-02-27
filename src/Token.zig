const std = @import("std");
const StaticStringMap = std.StaticStringMap;

// Kiểu Token
pub const Token = struct {
    token_type: TokenType,    // Loại token
    value: ?TokenValue, // Giá trị của token
    line: u128, // Vị trí dòng
    column: u128,   // Vị trí cột

    const Self = @This();

    pub fn init(token_type: TokenType, value: ?TokenValue, line: u128, column: u128) Token {
        return Token{
            .token_type = token_type,
            .value = value,
            .line = line,
            .column = column,
        };
    }

    pub fn toString(self: *Self) void {
        if (self.value) |value| {
            switch (value) {
                TokenValue.Char => {
                    std.debug.print("TokenType: {}, Value: {c}, Line: {}, Column: {}\n", .{self.*.token_type, self.*.value.?.Char, self.*.line, self.*.column});
                },
                TokenValue.String => {
                    std.debug.print("TokenType: {}, Value: {s}, Line: {}, Column: {}\n", .{self.*.token_type, self.*.value.?.String, self.*.line, self.*.column});
                },
                TokenValue.Bool => {
                    std.debug.print("TokenType: {}, Value: {}, Line: {}, Column: {}\n", .{self.*.token_type, self.*.value.?.Bool, self.*.line, self.*.column});
                },
                TokenValue.Int => {
                    std.debug.print("TokenType: {}, Value: {}, Line: {}, Column: {}\n", .{self.*.token_type, self.*.value.?.Int, self.*.line, self.*.column});
                },
                TokenValue.Float => {
                    std.debug.print("TokenType: {}, Value: {}, Line: {}, Column: {}\n", .{self.*.token_type, self.*.value.?.Float, self.*.line, self.*.column});
                },
            }
        } else {
            std.debug.print("TokenType: {}, Value: {any}, Line: {}, Column: {}\n", .{self.*.token_type, self.*.value, self.*.line, self.*.column});
        }
    }
};

// struct chứa token value
pub const TokenValue = union(TokenValueTag) {
    Char: u8,
    String: []const u8,
    Bool: bool,
    Int: i128,
    Float: f128,
};

// Tag cho TokenValue
pub const TokenValueTag = enum {
    Char,
    String,
    Bool,
    Int,
    Float,
};

// TokenType enum (phân loại các kiểu token)
pub const TokenType = enum {
    // Từ khoá
    In, // `in`
    Fn, // `function`
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
    Class,  // `class`
    Union, // `union`
    Error, // `error`
    Enum, // `enum`
    Null, // `null`
    True, // `true`
    False, // `false`
    Return, // `return`
    Throw,    // 'return!'

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

    // Toán tử đặc biệt
    LambdaArrow, // `=>`

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
};

// Keyword Map
pub const KeywordMap: StaticStringMap(TokenType) = StaticStringMap(TokenType).initComptime(.{
    .{"in", .In},
    .{"fn", .Fn},
    .{"if", .If},
    .{"else", .Else},
    .{"for", .For},
    .{"while", .While},
    .{"do", .Do},
    .{"and", .And},
    .{"or", .Or},
    .{"var", .Var},
    .{"const", .Const},
    .{"this", .This},
    .{"class", .Class},
    .{"union", .Union},
    .{"error", .Error},
    .{"enum", .Enum},
    .{"null", .Null},
    .{"true", .True},
    .{"false", .False},
    .{"return", .Return},
    .{"throw", .Throw},
});

// Các lỗi có thể có khi Lex token
pub const LexicalError = error {
    UndefinedToken, // Lỗi token không xác định
    InvalidStringLiteral,   // Lỗi string literal
    InvalidCharLiteral, // Lỗi char literal
    InvalidNumberLiteral,   // Lỗi number literal
};
