const std = @import("std");

const N = 1_000_000;

fn benchmark_unaligned() void {
    const unaligned_data: [N]u8 align(1) = std.mem.zeroes([N]u8);
    var sum: u64 = 0;

    for (unaligned_data) |value| {
        sum += @as(u64, value) + 1;
    }
}

fn benchmark_aligned() void {
    const aligned_data: [N]u8 align(8) = std.mem.zeroes([N]u8);
    var sum: u64 = 0;

    for (aligned_data) |value| {
        sum += @as(u64, value) + 1;
    }
}

pub fn main() void {
    // TODO: something weird happening here.
    // 1) aligned and unaligned pretty much have no difference in time.
    // 2) there is gap between aligned and unaligned -- not because of alignment, but because of just a order. the one goes first takes more time.
    // funny thing is this gap is like 2x in the first iteration, but when run again multiple times in short period, gap is gone.
    // feel like something with compiler is going on.
    const start_time_aligned = std.time.milliTimestamp();
    benchmark_aligned();
    const end_time_aligned = std.time.milliTimestamp();

    const start_time_unaligned = std.time.milliTimestamp();
    benchmark_unaligned();
    const end_time_unaligned = std.time.milliTimestamp();

    const aligned_duration = end_time_aligned - start_time_aligned;
    const unaligned_duration = end_time_unaligned - start_time_unaligned;

    std.debug.print("Aligned duration: {} ms\n", .{aligned_duration});
    std.debug.print("Unaligned duration: {} ms\n", .{unaligned_duration});
}
