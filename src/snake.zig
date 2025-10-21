const std = @import("std");
const gr = @import("grid.zig");
const Vector2I = @import("vector2i.zig").Vector2I;

pub const SnakeDir = enum {
    up,
    left,
    down,
    right,

    pub fn vector(self: SnakeDir) Vector2I {
        return switch (self) {
            .up => .{ .x = 0, .y = -1 },
            .left => .{ .x = -1, .y = 0 },
            .down => .{ .x = 0, .y = 1 },
            .right => .{ .x = 1, .y = 0 },
        };
    }
};

pub const SnakeBlock = struct {
    pos: Vector2I,
    dir: SnakeDir,
};

pub const Snake = struct {
    blocks: std.array_list.Managed(SnakeBlock),
    g: *gr.Grid,

    pub fn init(start_pos: Vector2I, start_dir: SnakeDir, allocator: std.mem.Allocator, grid: *gr.Grid) !Snake {
        var snake = Snake{
            .blocks = std.array_list.Managed(SnakeBlock).init(allocator),
            .g = grid,
        };

        try snake.g.occupy_cell(gr.CellType.player, start_pos);

        try snake.blocks.append(.{
            .pos = start_pos,
            .dir = start_dir,
        });

        return snake;
    }

    pub fn grow(self: *Snake) !void {
        const last_block = self.blocks.getLast();

        const x = last_block.pos.x - SnakeDir.vector(last_block.dir).x;
        const y = last_block.pos.y - SnakeDir.vector(last_block.dir).y;

        try self.g.occupy_cell(gr.CellType.player, .{ .x = x, .y = y });

        try self.blocks.append(.{
            .pos = .{ .x = x, .y = y },
            .dir = last_block.dir,
        });
    }

    pub fn change_direction(self: *Snake, dir: SnakeDir) void {
        self.blocks.items[0].dir = dir;
    }

    pub fn update_directions(self: *Snake) void {
        if (self.blocks.items.len == 1) {
            return;
        }

        var i: usize = self.blocks.items.len - 1;

        while (i > 0) : (i -= 1) {
            self.blocks.items[i].dir = self.blocks.items[i - 1].dir;
        }
    }

    // FIX: cannot grow
    pub fn update_movement(self: *Snake) !void {
        const prev_head_pos = self.blocks.items[0].pos;

        var i: usize = self.blocks.items.len - 1;

        while (i > 0) : (i -= 1) {
            self.g.deoccupy_cell(self.blocks.items[i].pos);
            self.blocks.items[i].pos = self.blocks.items[i - 1].pos;
            try self.g.occupy_cell(gr.CellType.player, self.blocks.items[i].pos);
        }

        self.blocks.items[0].pos.x += self.blocks.items[0].dir.vector().x;
        self.blocks.items[0].pos.y += self.blocks.items[0].dir.vector().y;

        try self.g.occupy_cell(gr.CellType.player, self.blocks.items[0].pos);

        self.g.deoccupy_cell(prev_head_pos);
    }
};
