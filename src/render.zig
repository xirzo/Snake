const s = @import("state.zig");
const Player = @import("state.zig").Player;
const State = @import("state.zig").State;
const rl = @import("raylib");

pub fn draw_grid() void {
    for (0..s.grid_cell_count) |i| {
        const pos_x: i32 = @as(i32, @intCast(i)) * s.grid_cell_side;

        for (0..s.grid_cell_count) |j| {
            const pos_y: i32 = @as(i32, @intCast(j)) * s.grid_cell_side;

            // zig fmt: off
            rl.drawRectangle(
                pos_x + s.grid_spacing / 2,
                pos_y + s.grid_spacing / 2,
                s.grid_cell_side - s.grid_spacing,
                s.grid_cell_side - s.grid_spacing,
                .dark_gray);
            // zig fmt: on
        }
    }
}

pub fn draw_player(player: *Player) void {
    for (player.snake.blocks.items) |block| {
        // zig fmt: off
        rl.drawRectangle(
            block.pos.x * s.grid_cell_side + s.grid_spacing / 2,
            block.pos.y * s.grid_cell_side + s.grid_spacing / 2, 
            s.grid_cell_side - s.grid_spacing, 
            s.grid_cell_side - s.grid_spacing, 
            player.color
        );
        // zig fmt: on
    }
}

pub fn draw_apples(state: *State) void {
    for (state.apples.items) |apple_pos| {
        // zig fmt: off
        rl.drawRectangle(
            apple_pos.x * s.grid_cell_side + s.grid_spacing / 2,
            apple_pos.y * s.grid_cell_side + s.grid_spacing / 2, 
            s.grid_cell_side - s.grid_spacing, 
            s.grid_cell_side - s.grid_spacing, 
            state.apple_color
        );
        // zig fmt: on
    }
}
