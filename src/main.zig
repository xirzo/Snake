const std = @import("std");
const rl = @import("raylib");
const stdout = @import("std").io.getStdOut().writer();
const Vector2I = @import("vector2i.zig").Vector2I;
const SnakeDir = @import("snake.zig").SnakeDir;

const screen_side: comptime_int = 600;
const grid_cell_count: comptime_int = 10;
const grid_spacing: comptime_int = 5;
const grid_cell_side: comptime_int = @divExact(screen_side, grid_cell_count);
const player_move_delay: comptime_float = 0.6;

const Player = struct {
    pos: std.ArrayList(Vector2I),
    dir: Vector2I = SnakeDir.vector(SnakeDir.up),
    move_timer: f64,
    color: rl.Color = .red,
};

const State = struct {
    player: Player,
};

fn processMovementInput(p: *Player) void {
    if (rl.isKeyPressed(.w)) {
        p.dir = SnakeDir.vector(SnakeDir.up);
    }
    if (rl.isKeyPressed(.a)) {
        p.dir = SnakeDir.vector(SnakeDir.left);
    }
    if (rl.isKeyPressed(.s)) {
        p.dir = SnakeDir.vector(SnakeDir.down);
    }
    if (rl.isKeyPressed(.d)) {
        p.dir = SnakeDir.vector(SnakeDir.right);
    }
}

fn movePlayer(player: *Player) void {
    if (player.move_timer < player_move_delay) {
        player.move_timer += rl.getFrameTime();
        return;
    }

    for (player.pos.items) |*pos| {
        pos.x += player.dir.x;
        pos.y += player.dir.y;
    }

    player.move_timer = 0;
}

fn drawGrid() void {
    for (0..grid_cell_count) |i| {
        const pos_x: i32 = @as(i32, @intCast(i)) * grid_cell_side;

        for (0..grid_cell_count) |j| {
            const pos_y: i32 = @as(i32, @intCast(j)) * grid_cell_side;

            rl.drawRectangle(pos_x + grid_spacing / 2, pos_y + grid_spacing / 2, grid_cell_side - grid_spacing, grid_cell_side - grid_spacing, .dark_gray);
        }
    }
}

fn drawPlayer(player: *Player) void {
    for (player.pos.items) |pos| {
        // zig fmt: off
        rl.drawRectangle(
            pos.x * grid_cell_side + grid_spacing / 2,
            pos.y * grid_cell_side + grid_spacing / 2, 
            grid_cell_side - grid_spacing, 
            grid_cell_side - grid_spacing, 
            player.color
        );
        // zig fmt: on
    }
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var state = State{
        .player = Player{
            .pos = std.ArrayList(Vector2I).init(allocator),
            .dir = SnakeDir.vector(SnakeDir.down),
            .move_timer = 0,
            .color = .green,
        },
    };

    try state.player.pos.append(.{ .x = 5, .y = 5 });

    rl.setTraceLogLevel(.none);
    rl.initWindow(screen_side, screen_side, "snake");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        processMovementInput(&state.player);
        movePlayer(&state.player);

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);
        drawGrid();
        drawPlayer(&state.player);
        rl.drawText(rl.textFormat("Dir x: %d, y: %d", .{ state.player.dir.x, state.player.dir.y }), 10, 10, 20, .white);
    }
}
