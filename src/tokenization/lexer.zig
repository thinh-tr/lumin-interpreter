const std = @import("std");
const ArrayList = std.ArrayList;
const Token = @import("./token.zig").Token;
const TokenType = @import("./token_type.zig").TokenType;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

// Struct chứa chức năng Lexer
pub const Lexer: type = struct {
    source: []const u8, // Trường chứa chuỗi mã nguồn cần scan
    tokens: ArrayList(Token),   // List chứa token đã được scan

    var start: usize = 0;   // index bắt đầu của lexeme đang xét
    var current: usize = 0; // index hiện tại của lexeme đang xét  
    var line: u128 = 1; // Vị trí dòng của lexeme đang xét

    // Khởi tạo Lexer
    pub fn init(allocator: GeneralPurposeAllocator, source: []const u8) Lexer {
        return Lexer{
            .source = source,
            .tokens = ArrayList(Token).init(allocator),
        };
    }

    // Huỷ Lexer
    pub fn deinit(self: @This()) void {
        self.tokens.deinit();   // Giải phóng bộ nhớ của list token
    }

    // Hàm scan token
    pub fn scanToken(self: @This()) !void {
        // Vòng lặp lớn
        while (!isAtEnd()) : (current += 1) {   // vòng lặp tự tăng chỉ số current cho đến khi đến cuối source
            start = current;

            // Nếu như gặp ký tự xuống dòng
            if (self.source[current] == '\n') {
                line += 1;  // Tăng line lên 1
                continue;   // Bắt đầu vòng lặp mới
            }

            // Nếu như gặp các ký tự khác không phải ký tự xuống dòng thì bắt đầu kiểm tra


        }
    }



    // Hàm kiểm tra xem vị trí đang xét đã ở cuối của source hay chưa
    fn isAtEnd(self: @This()) bool {
        return current >= self.source.len;  // true -> nếu như đã ở cuối source
    }

    // Hàm kiểm tra ký tự liền kề vị trí current (nếu vẫn chưa duyệt đến cuối source)
    fn advance(self: @This()) ?u8 {
        return if (!isAtEnd()) self.source[current + 1] else null;
    }

    // Hàm thêm token vừa tạo vào token list
    fn addToken(self: @This(), token: Token) !void {
        try self.tokens.append(token);
    }
};
