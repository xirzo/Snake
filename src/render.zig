const s = @import("state.zig");
const gr = @import("grid.zig");
const Player = @import("state.zig").Player;
const State = @import("state.zig").State;
const rl = @import("raylib");

pub const empty_color: rl.Color = .dark_gray;
pub const player_color: rl.Color = .green;
pub const apple_color: rl.Color = .red;

// TODO: add enum in state to determine which color to draw (Player, Apple, Empty)
pub fn draw_grid(grid: *gr.Grid) void {
    for (0..grid.cells.len) |i| {
        const pos_x: i32 = @as(i32, @intCast(i)) * s.grid_cell_side;

        for (0..grid.cells[0].len) |j| {
            const pos_y: i32 = @as(i32, @intCast(j)) * s.grid_cell_side;

            const cell_color: rl.Color = switch (grid.cells[i][j].type) {
                .empty => empty_color,
                .player => player_color,
                .apple => apple_color,
            };

            // zig fmt: off
            rl.drawRectangle(
                pos_x + s.grid_spacing / 2,
                pos_y + s.grid_spacing / 2,
                s.grid_cell_side - s.grid_spacing,
                s.grid_cell_side - s.grid_spacing,
                cell_color);
            // zig fmt: on
        }
    }
}

// pub fn draw_player(player: *Player) void {
//     for (player.snake.blocks.items) |block| {
//         // zig fmt: off
//         rl.drawRectangle(
//             block.pos.x * s.grid_cell_side + s.grid_spacing / 2,
//             block.pos.y * s.grid_cell_side + s.grid_spacing / 2,
//             s.grid_cell_side - s.grid_spacing,
//             s.grid_cell_side - s.grid_spacing,
//             player.color
//         );
//         // zig fmt: on
//     }
// }

// pub fn draw_apples(state: *State) void {
//     for (state.apples.items) |apple_pos| {
//         // zig fmt: off
//         rl.drawRectangle(
//             apple_pos.x * s.grid_cell_side + s.grid_spacing / 2,
//             apple_pos.y * s.grid_cell_side + s.grid_spacing / 2,
//             s.grid_cell_side - s.grid_spacing,
//             s.grid_cell_side - s.grid_spacing,
//             gr.apple_color
//         );
//         // zig fmt: on
//     }
// }
