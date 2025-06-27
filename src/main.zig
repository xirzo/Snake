const ap = @import("apple.zig");
const Cell = @import("grid.zig").Cell;
const Grid = @import("grid.zig").Grid;
const m = @import("movement.zig");
const Player = @import("state.zig").Player;
const r = @import("render.zig");
const s = @import("state.zig");
const Snake = @import("snake.zig").Snake;
const SnakeDir = @import("snake.zig").SnakeDir;
const State = @import("state.zig").State;
const Vector2I = @import("vector2i.zig").Vector2I;

// TODO: remove raylib from main
const rl = @import("raylib");
const std = @import("std");

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var state = State{
        .grid = Grid{
            .cells = .{.{Cell{ .is_empty = true }} ** s.grid_cell_count} ** s.grid_cell_count,
        },
        .player = Player{
            .snake = try Snake.init(.{ .x = 1, .y = 1 }, SnakeDir.right, allocator),
            .move_timer = 0,
        },
        .apples = std.ArrayList(Vector2I).init(allocator),
        .is_finished = false,
    };

    rl.setTraceLogLevel(.none);
    rl.initWindow(s.screen_side, s.screen_side, "snake");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        if (state.is_finished == false) {
            m.clamp_player_movement(&state, &state.player);
            m.process_movement_input(&state.player);
            m.move_player(&state.player);

            if (rl.isKeyPressed(.g)) {
                try state.player.snake.grow();
            }

            if (rl.isKeyPressed(.r)) {
                try ap.spawn_apple(&state.grid);
            }
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        if (state.is_finished == false) {
            r.draw_grid(&state.grid);
            // r.draw_player(&state.player);
            // r.draw_apples(&state);
        }
    }
}
