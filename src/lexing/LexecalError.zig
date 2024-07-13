pub const LexecalError = error {
    UndefinedToken, // Lỗi token không thể xác định
    IlligalCharacterLiteral,    // Lỗi char literal không hợp lệ
};