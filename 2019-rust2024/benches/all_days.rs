use aoc_2019::*;
use criterion::{Criterion, criterion_group, criterion_main};

pub fn day_01(c: &mut Criterion) {
    c.bench_function("day_01", |b| b.iter(day_01::run));
}

criterion_group!(benches, day_01);

criterion_main!(benches);
