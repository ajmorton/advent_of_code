mod intcode;

pub mod day_01;
pub mod day_02;
pub mod day_03;
pub mod day_04;
pub mod day_05;
pub mod day_06;

#[test] fn day_01() { assert_eq!(day_01::run(), (3125750, 4685788)); }
#[test] fn day_02() { assert_eq!(day_02::run(), (4930687, 5335)); }
#[test] fn day_03() { assert_eq!(day_03::run(), (1264, 37390)); }
#[test] fn day_04() { assert_eq!(day_04::run(), (1686, 1145)); }
#[test] fn day_05() { assert_eq!(day_05::run(), (7566643, 9265694)); }
#[test] fn day_06() { assert_eq!(day_06::run(), (402879, 484)); }
