const std = @import("std");
const Io = std.Io;
const log = std.debug.print;
const Session = @import("Net/Session.zig");

const PORT: u16 = 21065;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    const host = try Io.net.IpAddress.parse("127.0.0.1", PORT);
    var listener = try host.listen(io, .{ .reuse_address = true });
    defer listener.deinit(io);

    log("ReversalCounterpact running in {d}!\n", .{PORT});

    while (true) {
        const conn = listener.accept(io) catch continue;
        const tread = std.Thread.spawn(.{}, Session.handleClient, .{ io, conn }) catch {
            var stream = conn;
            stream.close(io);
            continue;
        };
        tread.detach();
    }
}
