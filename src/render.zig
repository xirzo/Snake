const s = @import("state.zig");
const gr = @import("grid.zig");
const rl = @import("raylib");

pub const empty_color: rl.Color = .dark_gray;
pub const player_color: rl.Color = .green;
pub const apple_color: rl.Color = .red;

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
