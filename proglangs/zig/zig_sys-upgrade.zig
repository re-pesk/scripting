///usr/bin/env -S zig run "$0" -- "$@"; exit $?

const std = @import ("std");

// Kalbos pranešimų šakos tipas
const LangMessages = std.StaticStringMap([]const u8);

// Pranešimų medžio tipas
const Messages = std.StaticStringMap(LangMessages);

// Pranešimų medis: kalbos kodas -> LangMessages
const messages = Messages.initComptime(.{
    .{ "en_US.UTF-8", LangMessages.initComptime(.{
        .{ "err", "Error! Script execution was terminated!" },
        .{ "succ", "Successfully finished!" },
        .{ "end", "End of execution." },
    }) },
    .{ "lt_LT.UTF-8", LangMessages.initComptime(.{
        .{ "err", "Klaida! Scenarijaus vykdymas sustabdytas!" },
        .{ "succ", "Komanda sėkmingai įvykdyta!" },
        .{ "end", "Scenarijaus vykdymas baigtas." },
    }) },
});

// Funkcija spalvotiems pranešimams išvesti
fn printMessage(key: []const u8, langMessages: LangMessages) !void {

    const message = langMessages.get(key) orelse messages.get("en_US.UTF-8").?.get(key) orelse return;
    const color = if (std.mem.eql(u8, key, "err")) "\x1b[31m" else "\x1b[32m";
    const reset = "\x1b[39m";

    std.debug.print("\n{s}{s}{s}\n", .{ color, message, reset });

    if (!std.mem.eql(u8, key, "succ")) {
        std.debug.print("\n", .{});
    }
}

// Išorinių komandų iškvietimo funkcija
fn runCmd(cmdArg: []const u8, langMessages: LangMessages, init: std.process.Init) !void {
    //Sukuriamas alocatorius
    var arena = init.arena;
    const allocator = arena.allocator();

    // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
    const command = try std.fmt.allocPrint(allocator, "{s} {s}", .{ "sudo", cmdArg });
    defer allocator.free(command);

    // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
    // allocator.alloc(u8, command.len) - sukuriama tuščia komandos ilgio eilutė
    // while (...)... - kiekvienas to eilutės ženklas pakeičiamas '-' simboliu
    const separator = try allocator.alloc(u8, command.len);
    defer allocator.free(separator);
    @memset(separator, '-');

    // Išvedama komandos eilutė, apsupta skirtuko eilučių
    std.debug.print("\n{s}\n{s}\n{s}\n\n", .{ separator, command, separator });

    // Sukuriamas argumentų masyvas
    var cmdArgsList = std.ArrayList([]const u8).initCapacity(init.gpa, 0) catch unreachable;
    defer cmdArgsList.deinit(init.gpa);

    // Masyvas užpildomas iš komandos eilutės
    var iterator = std.mem.tokenizeAny(u8, command, " ");
    while (iterator.next()) |word| {
        try cmdArgsList.append(init.gpa, word);
    }

    // Iš argumentų sukuriamas ir įvykdomas procesas, išėjimo kodas išsaugomas kintamjame
    var child = try std.process.spawn(init.io, .{
        .argv = cmdArgsList.items,
     });
    const exitTerm = try child.wait( init.io );

    // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
    if (exitTerm.exited > 0) {
        try printMessage("err", langMessages);
        std.os.linux.exit(99);
    }

    // Kitu atveju išvedamas sėkmės pranešimas
    try printMessage("succ", langMessages);
}

// Pagrindinė funkcija - programos įeigos taškas
pub fn main(init: std.process.Init) !void {
    // Gauti aplinkos kalbos nustatymus
    const lang = init.minimal.environ.getPosix("LANG") orelse "";

    // Paimti pranešimus, atitinkančius aplinkos kalbą
    const langMessages = messages.get(lang) orelse messages.get("en_US.UTF-8").?;

    // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
    try runCmd("apt-get update", langMessages, init);
    try runCmd("apt-get upgrade -y", langMessages, init);
    try runCmd("apt-get autoremove -y", langMessages, init);
    try runCmd("snap refresh", langMessages, init);

    // Scenarijaus baigties pranešimas
    try printMessage("end", langMessages);
}
