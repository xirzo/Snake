const std = @import("std");
const rl = @import("raylib");

const Vector2I = @import("vector2i.zig").Vector2I;
const Grid = @import("grid.zig").Grid;
const g = @import("grid.zig");
const Snake = @import("snake.zig").Snake;

pub const screen_side: comptime_int = 600;
pub const grid_cell_count: comptime_int = g.grid_cell_count;
pub const grid_spacing: comptime_int = 5;
pub const grid_cell_side: comptime_int = @divExact(screen_side, grid_cell_count);
pub const player_move_delay: comptime_float = 0.5;

pub const Player = struct {
    snake: Snake,
    move_timer: f64,
};

pub const State = struct {
    grid: Grid,
    player: Player,
    is_finished: bool,
    apples: std.ArrayList(Vector2I),
};

pub fn finish_game(state: *State) void {
    state.is_finished = true;
}
