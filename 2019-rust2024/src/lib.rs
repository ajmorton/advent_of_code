mod intcode;

pub mod day_01;
pub mod day_02;

#[test] fn day_01() { assert_eq!(day_01::run(), (3125750, 4685788)); }
#[test] fn day_02() { assert_eq!(day_02::run(), (4930687, 5335)); }
