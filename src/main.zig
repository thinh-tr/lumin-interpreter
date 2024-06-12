const std = @import("std");
const argsAlloc = std.process.argsAlloc;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const args = try argsAlloc(std.heap.page_allocator);    // Nhận vào args từ console
    defer std.heap.page_allocator.free(args);   // Giải phóng args khỏi bộ nhớ

    // Xuất ra thông tin đối số
    // for (args, 0..) |arg, i| {
    //     try stdout.print("Arg {}: {s}\n", .{i, arg});
    // }

    if (args.len > 1) {
        try stdout.writeAll("Usage: lumin [script]");
        std.process.exit(64);
    } else if (args.len == 1) {
        // run file function
    } else {
        // run prompt
    }
}