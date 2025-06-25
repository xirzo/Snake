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

pub const Vector2I = struct {
    x: i16,
    y: i16,
};
