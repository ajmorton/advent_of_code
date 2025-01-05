mod intcode;

pub mod day_01;
pub mod day_02;
pub mod day_03;
pub mod day_04;
pub mod day_05;
pub mod day_06;
pub mod day_07;
pub mod day_08;
pub mod day_09;
pub mod day_10;
pub mod day_11;
pub mod day_12;
pub mod day_13;
pub mod day_14;
pub mod day_15;

#[test] fn day_01() { assert_eq!(day_01::run(), (3125750, 4685788)); }
#[test] fn day_02() { assert_eq!(day_02::run(), (4930687, 5335)); }
#[test] fn day_03() { assert_eq!(day_03::run(), (1264, 37390)); }
#[test] fn day_04() { assert_eq!(day_04::run(), (1686, 1145)); }
#[test] fn day_05() { assert_eq!(day_05::run(), (7566643, 9265694)); }
#[test] fn day_06() { assert_eq!(day_06::run(), (402879, 484)); }
#[test] fn day_07() { assert_eq!(day_07::run(), (440880, 3745599)); }
#[test] fn day_08() { assert_eq!(day_08::run(), (1950, 
"\
#### #  #  ##  #  # #    
#    # #  #  # #  # #    
###  ##   #  # #### #    
#    # #  #### #  # #    
#    # #  #  # #  # #    
#    #  # #  # #  # #### 
".to_string())); }
#[test] fn day_09() { assert_eq!(day_09::run(), (2752191671, 87571)); }
#[test] fn day_10() { assert_eq!(day_10::run(), (260, 608)); }
#[test] fn day_11() { assert_eq!(day_11::run(), (2056, 
"  ##  #    ###  #### ###    ## #### ###    
 #  # #    #  # #    #  #    #    # #  #   
 #    #    ###  ###  #  #    #   #  #  #   
 # ## #    #  # #    ###     #  #   ###    
 #  # #    #  # #    #    #  # #    #      
  ### #### ###  #### #     ##  #### #      
".to_string())); }
#[test] fn day_12() { assert_eq!(day_12::run(), (6220, 548525804273976)); }
#[test] fn day_13() { assert_eq!(day_13::run(), (180, 8777)); }
#[test] fn day_14() { assert_eq!(day_14::run(), (365768, 3756877)); }
#[test] fn day_15() { assert_eq!(day_15::run(), (294, 388)); }
