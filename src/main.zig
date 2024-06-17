const std = @import("std");
const argsAlloc = std.process.argsAlloc;
const stdout = std.io.getStdOut().writer();
const page_allocator = std.heap.page_allocator;
const fs = std.fs; // Filesystem
const FileOpenError = std.fs.File.OpenError;

pub fn main() !void {
    const args: [][]u8 = try argsAlloc(std.heap.page_allocator); // Nhận vào args từ console
    defer std.heap.page_allocator.free(args); // Giải phóng args khỏi bộ nhớ

    try stdout.writeAll("Usage: lumin [command] [options]\n");

    // Hiển thị các tuỳ chọn thông qua args đầu vào
    if (args.len == 1) {
        // Hiển thị help-menu khi không có arg đầu vào
        try showHelpMenu();
    } else if (args.len >= 3) {
        // Trường hợp có command đầu vào -> Kiểm tra command đầu vào đó
        if (std.mem.eql(u8, args[1], "run")) {
            // Lệnh run -> tiến hành phân tích và thực thi mã
            try runFile(args[2]);
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

// Thực thi source code nằm tại path nhất định
pub fn runFile(path: []const u8) !void {
    const source_file: fs.File = fs.openFileAbsolute(path, .{ .mode = .read_only }) catch |err| {
        try reportError(try std.fmt.allocPrint(page_allocator, "{!}", .{err}));
        return;
    };
    const source_content: ?[]u8 = try source_file.readToEndAlloc(page_allocator, std.math.maxInt(usize));
    defer page_allocator.free(source_content.?);
    try stdout.print("File content: {s}\n", .{source_content.?});
    //try run(source_content);
}

// Hàm thực thi source ở định dạng String
// pub fn run(source: []u8) !void {

//     // Thử nghiệm việc phân tích và in ra tất cả các token có trong source code
// }
