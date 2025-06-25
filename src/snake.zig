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

const SnakeBlock = struct {
    dir: Vector2I,
    pos: Vector2I,
};
