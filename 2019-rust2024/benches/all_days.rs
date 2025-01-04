use aoc_2019::*;
use criterion::{Criterion, criterion_group, criterion_main};

pub fn day_01(c: &mut Criterion) { c.bench_function("day_01", |b| b.iter(day_01::run)); }
pub fn day_02(c: &mut Criterion) { c.bench_function("day_02", |b| b.iter(day_02::run)); }
pub fn day_03(c: &mut Criterion) { c.bench_function("day_03", |b| b.iter(day_03::run)); }
pub fn day_04(c: &mut Criterion) { c.bench_function("day_04", |b| b.iter(day_04::run)); }
pub fn day_05(c: &mut Criterion) { c.bench_function("day_05", |b| b.iter(day_05::run)); }
pub fn day_06(c: &mut Criterion) { c.bench_function("day_06", |b| b.iter(day_06::run)); }
pub fn day_07(c: &mut Criterion) { c.bench_function("day_07", |b| b.iter(day_07::run)); }

criterion_group!(benches, day_01, day_02, day_03, day_04, day_05, day_06, day_07);
criterion_main!(benches);
