const std = @import("std");
const argsAlloc = std.process.argsAlloc;
const stdout = std.io.getStdOut().writer();
const page_allocator = std.heap.page_allocator;

pub fn main() !void {
    const args: [][]u8 = try argsAlloc(std.heap.page_allocator);    // Nhận vào args từ console
    defer std.heap.page_allocator.free(args);   // Giải phóng args khỏi bộ nhớ
    
    try stdout.writeAll("Usage: lumin [command] [options]\n");

    // Hiển thị các tuỳ chọn thông qua args đầu vào
    if (args.len == 1) {
        // Hiển thị help-menu khi không có arg đầu vào
        try showHelpMenu();
    } else if (args.len >= 3) {
        // Trường hợp có command đầu vào -> Kiểm tra command đầu vào đó
        if (std.mem.eql(u8, args[1], "run")) {
            // Lệnh run -> tiến hành phân tích và thực thi mã
            try stdout.writeAll("run script here!");
        } else if (std.mem.eql(u8, args[1], "help")) {
            // Lệnh help -> hiển thị help menu
            try showHelpMenu();
        } else {
            // Trường hợp không nhận ra command này
            try reportError(try std.fmt.allocPrint(page_allocator, "unknown command '{s}'", .{args[1]}));
        }
    }
}

// Hiển thị menu trợ giúp
pub fn showHelpMenu() !void {
    try stdout.writeAll(
        \\Command:
        \\  run   Run script file
        \\  help  Print help menu and exit
    );
}

// Thông báo lỗi
pub fn reportError(message: []u8) !void {
    try stdout.print("error: {s}\n", .{message});
}