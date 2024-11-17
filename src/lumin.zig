const std = @import("std");
const stdout = std.io.getStdOut().writer();
const page_allocator = std.heap.page_allocator;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;
const File = std.fs.File; // File type
const fmt = std.fmt;    // String format

// Entry function
pub fn main() !void {
    const args = try std.process.argsAlloc(page_allocator); // Nhận vào args từ console
    defer std.process.argsFree(page_allocator, args); // giải phóng bộ nhớ của args

    // Thực hiện các chức năng thông qua args đầu vào
    switch (args.len) {
        1 => {
            try showHelpMenu(); // Hiển thị help menu nếu chỉ có 1 args
            std.process.exit(64); // thoát chương trình
        },
        else => { // Các trường hợp có từ 2 args trở lên (Chương trình luôn luôn nhận vào số args >= 1)
            // Tiến hành kiển tra command đầu vào
            switch (InputCommand.getCommand(args[1])) {
                // Nếu là lệnh RUN -> phân tích và thực thi mã
                InputCommand.RUN => {
                    // Kiểm tra xem args có chứa args cho path của file mã cần thực thi không
                    if (args.len >= 3) {
                        // tiến hành thực thi mã
                        try run(args[2]);
                    } else {
                        try reportError(try fmt.allocPrint(page_allocator, "Source file is not specified.", .{}));  // Thông báo lỗi
                    }
                },

                // Nếu là lệnh HELP -> hiển thị help menu
                InputCommand.HELP => {
                    // Hiển thị help menu
                    try showHelpMenu();
                },

                // Trong trường hợp không thể nhận ra command đầu vào
                else => {
                    // Thông báo lỗi
                    try reportError(try fmt.allocPrint(page_allocator, "The command '{s}' is not supported.", .{args[1]}));
                    return;
                }
            }
        },
    }
}

// Enum chứa các command được hỗ trợ
const InputCommand = enum {
    RUN, // run script
    HELP, // help menu
    UNSUPPORTED, // unsupported command

    const Self = @This();

    // Quy đổi command đầu vào sang kiểu string
    pub fn getCommand(string_arg_command: []const u8) InputCommand {
        if (std.mem.eql(u8, string_arg_command, "run")) {
            // run command
            return InputCommand.RUN;
        } else if (std.mem.eql(u8, string_arg_command, "help")) {
            // help command
            return InputCommand.HELP;
        } else {
            return InputCommand.UNSUPPORTED;
        }
    }
};

// Hiển thị menu trợ giúp
pub fn showHelpMenu() !void {
    try stdout.writeAll(
        \\Usage: lumin [command] [options]
        \\Command:
        \\  run   Run script file
        \\  help  Print help menu and exit
        \\
    );
}

// Thông báo lỗi
pub fn reportError(message: []u8) !void {
    try stdout.print("Error: {s}\n", .{message});
}

// Thực thi source code nằm tại path nhất định
pub fn run(path: []const u8) !void {
    // Phương thức open file theo đường dẫn tương đối sử dụng cwd()
    const source_file: File = std.fs.cwd().openFile(path, File.OpenFlags{ .mode = .read_only }) catch |err| {
        try reportError(try fmt.allocPrint(page_allocator, "{!}", .{err})); // Thông báo lỗi nếu không tìm thấy file cần thực thi
        return; // Thoát hàm
    };
    const source_content: ?[]u8 = try source_file.readToEndAlloc(page_allocator, std.math.maxInt(usize));
    defer page_allocator.free(source_content.?);
    try stdout.print("File content: {s}\n", .{source_content.?});
    //try run(source_content);
}