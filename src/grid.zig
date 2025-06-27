const Vector2I = @import("vector2i.zig").Vector2I;

pub const grid_cell_count = 10;

const GridError = error{
    CellAlreadyOccupied,
};

pub const Cell = struct {
    is_empty: bool = true,
};

pub const Grid = struct {
    cells: [grid_cell_count][grid_cell_count]Cell,

    pub fn is_cell_empty(self: *Grid, pos: Vector2I) bool {
        return self.cells[@as(usize, @intCast(pos.x))][@as(usize, @intCast(pos.y))].is_empty;
    }

    pub fn occupy_cell(self: *Grid, pos: Vector2I) GridError!void {
        if (is_cell_empty(self, pos) == false) {
            return error.CellAlreadyOccupied;
        }

        self.cells[@as(usize, @intCast(pos.x))][@as(usize, @intCast(pos.y))].is_empty = false;
    }
};
