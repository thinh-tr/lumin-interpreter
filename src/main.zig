const std = @import("std");
const stdout = std.io.getStdOut().writer();
const page_allocator = std.heap.page_allocator;
const File = std.fs.File;   // File type

pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator); // Nhận vào args từ console
    defer std.process.argsFree(page_allocator, args);

    try stdout.writeAll("Usage: lumin [command] [options]\n");

    // Hiển thị các tuỳ chọn thông qua args đầu vào
    if (args.len == 1) {
        // Hiển thị help-menu khi không có arg đầu vào
        try showHelpMenu();
    } else if (args.len >= 2) {
        // Trường hợp có command đầu vào -> Kiểm tra command đầu vào đó
        if (std.mem.eql(u8, args[1], "run")) {
            // Kiểm tra điều kiện lệnh có độ dài từ 3 tham số trở lên
            if (args.len >= 3) {
                // Lệnh run -> tiến hành phân tích và thực thi mã
                try runFile(args[2]);
            } else {
                // Trường hợp không nhận được tham số thứ 3
                try reportError(try std.fmt.allocPrint(page_allocator, "Source file is not specified.", .{}));
                std.process.exit(64);
            }
        } else if (std.mem.eql(u8, args[1], "help")) {
            // Lệnh help -> hiển thị help menu
            try showHelpMenu();
        } else {
            // Trường hợp không nhận ra command này
            try reportError(try std.fmt.allocPrint(page_allocator, "unknown command '{s}'", .{args[1]}));
        }
    } else std.process.exit(64);
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
    // Phương thức open file theo đường dẫn tương đối sử dụng cwd()
    const source_file: File = std.fs.cwd().openFile(path, File.OpenFlags{ .mode = .read_only }) catch |err| {
        try reportError(try std.fmt.allocPrint(page_allocator, "{!}", .{err}));
        return; // Thoát hàm
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
