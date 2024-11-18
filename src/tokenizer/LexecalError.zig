pub const LexecalError = error {
    UndefinedToken, // Lỗi token không thể xác định
    IlligalCharacterLiteral,    // Lỗi char literal không hợp lệ
    IllegalStringLiteral,   // Lỗi string literal không hợp lệ
    IllegalNumberLiteral,   // Lỗi number literal không hợp lệ
};