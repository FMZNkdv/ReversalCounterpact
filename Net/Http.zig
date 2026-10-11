const std = @import("std");
const Io = std.Io;

pub fn headerVal(head: []const u8, name: []const u8) ?[]const u8 {
    var lines = std.mem.splitScalar(u8, head, '\n');
    _ = lines.next();
    while (lines.next()) |line| {
        const c = std.mem.indexOfScalar(u8, line, ':') orelse continue;
        if (c == 0) continue;
        if (std.ascii.eqlIgnoreCase(trim(line[0..c]), name)) return trim(line[c + 1 ..]);
    }
    return null;
}

fn trim(s: []const u8) []const u8 {
    var a: usize = 0;
    var b: usize = s.len;
    while (a < b and (s[a] == ' ' or s[a] == '\t' or s[a] == '\r')) : (a += 1) {}
    while (b > a and (s[b - 1] == ' ' or s[b - 1] == '\t' or s[b - 1] == '\r')) : (b -= 1) {}
    return s[a..b];
}

pub fn headEnd(data: []const u8) ?usize {
    if (std.mem.indexOf(u8, data, "\r\n\r\n")) |i| return i;
    if (std.mem.indexOf(u8, data, "\n\n")) |i| return i;
    return null;
}

pub fn respond(io: Io, stream: Io.net.Stream, body: []const u8, ctype: []const u8) !void {
    var sbuf: [1024]u8 = undefined;
    var w = stream.writer(io, &sbuf);
    try w.interface.print("HTTP/1.1 200 OK\r\nContent-Type: {s}\r\nContent-Length: {d}\r\nConnection: close\r\n\r\n", .{ ctype, body.len });
    try w.interface.writeAll(body);
    try w.interface.flush();
}
