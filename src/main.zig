const rl = @import("raylib");

const SnakeDir = @import("snake.zig").SnakeDir;
const Vector2I = @import("vector2i.zig").Vector2I;
const Snake = @import("snake.zig").Snake;

const std = @import("std");
const stdout = @import("std").io.getStdOut().writer();
const screen_side: comptime_int = 600;
const grid_cell_count: comptime_int = 10;
const grid_spacing: comptime_int = 5;
const grid_cell_side: comptime_int = @divExact(screen_side, grid_cell_count);
const player_move_delay: comptime_float = 0.6;

const Player = struct {
    snake: Snake,
    move_timer: f64,
    color: rl.Color = .red,
};

const State = struct {
    player: Player,
};

fn processMovementInput(p: *Player) void {
    if (rl.isKeyPressed(.w)) {
        p.snake.change_direction(SnakeDir.up);
    }
    if (rl.isKeyPressed(.a)) {
        p.snake.change_direction(SnakeDir.left);
    }
    if (rl.isKeyPressed(.s)) {
        p.snake.change_direction(SnakeDir.down);
    }
    if (rl.isKeyPressed(.d)) {
        p.snake.change_direction(SnakeDir.right);
    }
}

fn movePlayer(player: *Player) void {
    if (player.move_timer < player_move_delay) {
        player.move_timer += rl.getFrameTime();
        return;
    }

    player.snake.update_directions();
    player.snake.update_movement();

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
    for (player.snake.blocks.items) |block| {
        // zig fmt: off
        rl.drawRectangle(
            block.pos.x * grid_cell_side + grid_spacing / 2,
            block.pos.y * grid_cell_side + grid_spacing / 2, 
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
            .snake = try Snake.init(.{ .x = 1, .y = 1 }, SnakeDir.right, allocator),
            .move_timer = 0,
            .color = .green,
        },
    };

    rl.setTraceLogLevel(.none);
    rl.initWindow(screen_side, screen_side, "snake");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        processMovementInput(&state.player);
        movePlayer(&state.player);

        if (rl.isKeyPressed(.g)) {
            try state.player.snake.grow();
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);
        drawGrid();
        drawPlayer(&state.player);
        // rl.drawText(rl.textFormat("Dir x: %d, y: %d", .{ state.player.dir.x, state.player.dir.y }), 10, 10, 20, .white);
    }
}
