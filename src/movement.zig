const rl = @import("raylib");
const SnakeDir = @import("snake.zig").SnakeDir;
const Vector2I = @import("vector2i.zig").Vector2I;
const s = @import("state.zig");
const State = @import("state.zig").State;
const Grid = @import("grid.zig").Grid;
const Cell = @import("grid.zig").Cell;
const Player = @import("state.zig").Player;
const Snake = @import("snake.zig").Snake;
const ap = @import("apple.zig");
const r = @import("render.zig");
const std = @import("std");
const stdout = @import("std").io.getStdOut().writer();

pub fn process_movement_input(p: *Player) void {
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

pub fn move_player(player: *Player) !void {
    if (player.move_timer < s.player_move_delay) {
        player.move_timer += rl.getFrameTime();
        return;
    }

    player.snake.update_directions();
    try player.snake.update_movement();

    player.move_timer = 0;
}

pub fn clamp_player_movement(state: *State, player: *Player) void {
    const pos: Vector2I = player.snake.blocks.items[0].pos;

    if (pos.x < 0 or pos.x >= s.grid_cell_count) {
        s.finish_game(state);
    }
    if (pos.y < 0 or pos.y >= s.grid_cell_count) {
        s.finish_game(state);
    }
}
