const std = @import("std");
const Io = std.Io;
const heap = std.heap.page_allocator;
const log = std.debug.print;
const Http = @import("Http.zig");
const Account = @import("../DataBase/Account.zig");

fn isHttp(data: []const u8) bool {
    if (std.mem.startsWith(u8, data, "GET ")) return true;
    if (std.mem.startsWith(u8, data, "POST ")) return true;
    if (std.mem.startsWith(u8, data, "HEAD ")) return true;
    if (std.mem.indexOf(u8, data, "HTTP/1.") != null) return true;
    return false;
}

pub fn handleClient(io: Io, stream: Io.net.Stream) void {
    var conn = stream;
    defer conn.close(io);

    var acc: std.ArrayListUnmanaged(u8) = .empty;
    var tmp: [4096]u8 = undefined;

    while (true) {
        var buf = [_][]u8{tmp[0..]};
        const read = conn.read(io, &buf) catch return;
        if (read == 0) return;
        acc.appendSlice(heap, tmp[0..read]) catch return;
        const text = acc.items;
        if (!isHttp(text)) {
            if (text.len > 8192) return;
            continue;
        }

        if (Http.headEnd(text) == null and text.len <= 4096) continue;

        const lobby = Http.headerVal(text, "Lobby");
        if (lobby != null and std.ascii.eqlIgnoreCase(lobby.?, "true")) {
            log("lobby\n", .{});
            Http.respond(io, conn, "[]", "application/json") catch return;
            return;
        }

        const request = Http.headerVal(text, "Request");
        log("{s}\n", .{request orelse "money"});
        Http.respond(io, conn, Account.handle(request), "text/html") catch return;
        return;
    }
}
