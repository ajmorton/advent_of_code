use criterion::{criterion_group, criterion_main, Criterion};
use aoc_2018::*;

pub fn day_01(c: &mut Criterion) { c.bench_function("day_01", |b| b.iter(day_01::run)); }
pub fn day_02(c: &mut Criterion) { c.bench_function("day_02", |b| b.iter(day_02::run)); }
pub fn day_03(c: &mut Criterion) { c.bench_function("day_03", |b| b.iter(day_03::run)); }
pub fn day_04(c: &mut Criterion) { c.bench_function("day_04", |b| b.iter(day_04::run)); }
pub fn day_05(c: &mut Criterion) { c.bench_function("day_05", |b| b.iter(day_05::run)); }
pub fn day_06(c: &mut Criterion) { c.bench_function("day_06", |b| b.iter(day_06::run)); }
pub fn day_07(c: &mut Criterion) { c.bench_function("day_07", |b| b.iter(day_07::run)); }
pub fn day_08(c: &mut Criterion) { c.bench_function("day_08", |b| b.iter(day_08::run)); }
pub fn day_09(c: &mut Criterion) { c.bench_function("day_09", |b| b.iter(day_09::run)); }
pub fn day_10(c: &mut Criterion) { c.bench_function("day_10", |b| b.iter(day_10::run)); }
pub fn day_11(c: &mut Criterion) { c.bench_function("day_11", |b| b.iter(day_11::run)); }
pub fn day_12(c: &mut Criterion) { c.bench_function("day_12", |b| b.iter(day_12::run)); }
pub fn day_13(c: &mut Criterion) { c.bench_function("day_13", |b| b.iter(day_13::run)); }
pub fn day_14(c: &mut Criterion) { c.bench_function("day_14", |b| b.iter(day_14::run)); }
pub fn day_15(c: &mut Criterion) { c.bench_function("day_15", |b| b.iter(day_15::run)); }
pub fn day_16(c: &mut Criterion) { c.bench_function("day_16", |b| b.iter(day_16::run)); }
pub fn day_17(c: &mut Criterion) { c.bench_function("day_17", |b| b.iter(day_17::run)); }
pub fn day_18(c: &mut Criterion) { c.bench_function("day_18", |b| b.iter(day_18::run)); }
pub fn day_19(c: &mut Criterion) { c.bench_function("day_19", |b| b.iter(day_19::run)); }
pub fn day_20(c: &mut Criterion) { c.bench_function("day_20", |b| b.iter(day_20::run)); }
pub fn day_21(c: &mut Criterion) { c.bench_function("day_21", |b| b.iter(day_21::run)); }
pub fn day_22(c: &mut Criterion) { c.bench_function("day_22", |b| b.iter(day_22::run)); }
pub fn day_23(c: &mut Criterion) { c.bench_function("day_23", |b| b.iter(day_23::run)); }
pub fn day_24(c: &mut Criterion) { c.bench_function("day_24", |b| b.iter(day_24::run)); }
pub fn day_25(c: &mut Criterion) { c.bench_function("day_25", |b| b.iter(day_25::run)); }

criterion_group!(benches, day_01, day_02, day_03, day_04, day_05, day_06, day_07, day_08, day_09, day_10, 
                          day_11, day_12, day_13, day_14, day_15, day_16, day_17, day_18, day_19, day_20, 
                          day_21, day_22, day_23, day_24, day_25);

criterion_main!(benches);