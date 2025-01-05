use aoc_2019::*;
use criterion::{Criterion, criterion_group, criterion_main};

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

criterion_group!(benches, day_01, day_02, day_03, day_04, day_05, day_06, day_07, day_08, day_09, day_10,
                          day_11, day_12);
criterion_main!(benches);
