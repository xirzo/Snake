const Vector2I = @import("vector2i.zig").Vector2I;
const gr = @import("grid.zig");

const std = @import("std");

const get_pos_attempts: comptime_int = 30;

const RandomError = error{
    FailedToGetRandomSeed,
    CannotGetRandomPosAllAttempts,
};

fn get_random_pos() !Vector2I {
    var seed: u64 = undefined;

    std.posix.getrandom(std.mem.asBytes(&seed)) catch {
        return RandomError.FailedToGetRandomSeed;
    };

    var prng = std.Random.DefaultPrng.init(seed);
    const rng = prng.random();

    const x = std.Random.intRangeAtMost(rng, i16, 0, gr.grid_cell_count - 1);
    const y = std.Random.intRangeAtMost(rng, i16, 0, gr.grid_cell_count - 1);

    return .{ .x = x, .y = y };
}

// FIX: spawn apple in another apple
pub fn spawn_apple(grid: *gr.Grid) !void {
    var pos = try get_random_pos();

    var attempts: usize = 0;

    while (grid.is_cell_empty(pos) == false) {
        if (attempts >= get_pos_attempts) {
            return;
        }

        pos = try get_random_pos();
        attempts += 1;
    }

    try grid.occupy_cell(gr.CellType.apple, pos);
}
