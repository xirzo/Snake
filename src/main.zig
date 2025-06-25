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
const player_move_delay: comptime_float = 0.5;

const Player = struct {
    snake: Snake,
    move_timer: f64,
    color: rl.Color = .red,
};

const State = struct {
    player: Player,
    is_finished: bool,
    apples: std.ArrayList(Vector2I),
    apple_color: rl.Color,
};

fn finish_game(state: *State) void {
    state.is_finished = true;
}

const RandomError = error{
    FailedToGetRandomSeed,
};

fn get_random_pos() !Vector2I {
    var seed: u64 = undefined;

    std.posix.getrandom(std.mem.asBytes(&seed)) catch |err| {
        std.debug.print("Failed to get random seed: {}\n", .{err});
        return RandomError.FailedToGetRandomSeed;
    };

    var prng = std.Random.DefaultPrng.init(seed);
    const rng = prng.random();

    const x = std.Random.intRangeAtMost(rng, i16, 0, grid_cell_count);
    const y = std.Random.intRangeAtMost(rng, i16, 0, grid_cell_count);

    return .{ .x = x, .y = y };
}

// FIX: rewrite algorithm
// FIX: spawn apple in another apple
fn spawn_apple(state: *State) !void {
    var pos = try get_random_pos();

    for (state.player.snake.blocks.items) |block| {
        while (block.pos.x == pos.x or block.pos.y == pos.y) {
            pos = try get_random_pos();
        }
    }

    try state.apples.append(pos);
}

fn process_movement_input(p: *Player) void {
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

fn move_player(player: *Player) void {
    if (player.move_timer < player_move_delay) {
        player.move_timer += rl.getFrameTime();
        return;
    }

    player.snake.update_directions();
    player.snake.update_movement();

    player.move_timer = 0;
}

fn detect_wall_collision(state: *State, player: *Player) void {
    const pos: Vector2I = player.snake.blocks.items[0].pos;

    if (pos.x < 0 or pos.x >= grid_cell_count) {
        finish_game(state);
    }
    if (pos.y < 0 or pos.y >= grid_cell_count) {
        finish_game(state);
    }
}

fn draw_grid() void {
    for (0..grid_cell_count) |i| {
        const pos_x: i32 = @as(i32, @intCast(i)) * grid_cell_side;

        for (0..grid_cell_count) |j| {
            const pos_y: i32 = @as(i32, @intCast(j)) * grid_cell_side;

            rl.drawRectangle(pos_x + grid_spacing / 2, pos_y + grid_spacing / 2, grid_cell_side - grid_spacing, grid_cell_side - grid_spacing, .dark_gray);
        }
    }
}

fn draw_player(player: *Player) void {
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

fn draw_apples(state: *State) void {
    for (state.apples.items) |apple_pos| {
        // zig fmt: off
        rl.drawRectangle(
            apple_pos.x * grid_cell_side + grid_spacing / 2,
            apple_pos.y * grid_cell_side + grid_spacing / 2, 
            grid_cell_side - grid_spacing, 
            grid_cell_side - grid_spacing, 
            state.apple_color
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
        .apples = std.ArrayList(Vector2I).init(allocator),
        .apple_color = .red,
        .is_finished = false,
    };

    rl.setTraceLogLevel(.none);
    rl.initWindow(screen_side, screen_side, "snake");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        if (state.is_finished == false) {
            detect_wall_collision(&state, &state.player);
            process_movement_input(&state.player);
            move_player(&state.player);

            if (rl.isKeyPressed(.g)) {
                try state.player.snake.grow();
            }

            if (rl.isKeyPressed(.r)) {
                try spawn_apple(&state);
            }
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        if (state.is_finished == false) {
            draw_grid();
            draw_player(&state.player);
            draw_apples(&state);
        }
    }
}
