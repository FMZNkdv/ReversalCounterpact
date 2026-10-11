const std = @import("std");

const login =
    "<<USER_ID>>1<<END>>" ++
    "<<SESSION_ID>>9000000SESSION<<END>>" ++
    "<<ROLE_ID>>0<<END>>" ++
    "<<MONEY>>9999999<<END>>" ++
    "<<NEWS_TITLE>>ReversalCounterpact<<END>>" ++
    "<<NEWS_DESC>>ReversalCounterpact\nby FMZNkdv<<END>>" ++
    "<<NEWS_DATE>>0,0,0<<END>>" ++
    "<<NEWS_EVENT>>autumn<<END>>";

const news =
    "<<NEWS_TITLE>>ReversalCounterpact<<END>>" ++
    "<<NEWS_DESC>>ReversalCounterpact\nby FMZNkdv\n\ngithub.com/fmznkdv/reversalcounterpact\ngithub.com/fmznkdv/reversalcounterpact\ngithub.com/fmznkdv/reversalcounterpact<<END>>" ++
    "<<NEWS_DATE>>0,0,0<<END>>" ++
    "<<NEWS_EVENT>>autumn<<END>>";

pub fn handle(req: ?[]const u8) []const u8 {
    const r = req orelse return "<<MONEY>>9999999<<END>>";
    const ascii = std.ascii.eqlIgnoreCase;
    if (ascii(r, "news")) return news;

    if (ascii(r, "linkedlogin")) return login;
    if (ascii(r, "login")) return login;
    if (ascii(r, "register")) return login;

    return "<<MONEY>>9999999<<END>>";
}
