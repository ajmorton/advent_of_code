use aoc_2019::*;
use criterion::{Criterion, criterion_group, criterion_main};

pub fn day_01(c: &mut Criterion) { c.bench_function("day_01", |b| b.iter(day_01::run)); }
pub fn day_02(c: &mut Criterion) { c.bench_function("day_02", |b| b.iter(day_02::run)); }

criterion_group!(benches, day_01, day_02);
criterion_main!(benches);
