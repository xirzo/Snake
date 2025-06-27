const Vector2I = @import("vector2i.zig").Vector2I;
const gr = @import("grid.zig");

const std = @import("std");

const RandomError = error{
    FailedToGetRandomSeed,
};

fn get_random_pos(max: i16) !Vector2I {
    var seed: u64 = undefined;

    std.posix.getrandom(std.mem.asBytes(&seed)) catch {
        return RandomError.FailedToGetRandomSeed;
    };

    var prng = std.Random.DefaultPrng.init(seed);
    const rng = prng.random();

    const x = std.Random.intRangeAtMost(rng, i16, 0, max);
    const y = std.Random.intRangeAtMost(rng, i16, 0, max);

    return .{ .x = x, .y = y };
}

// FIX: rewrite algorithm
// FIX: spawn apple in another apple
pub fn spawn_apple(_: gr.Grid) !void {
    var pos = try get_random_pos();

    for (.player.snake.blocks.items) |block| {
        while (block.pos.x == pos.x or block.pos.y == pos.y) {
            pos = try get_random_pos();
        }
    }

    // FIX: spawn on grid, continue spawning if cell is blocked
    // try state.apples.append(pos);
}
