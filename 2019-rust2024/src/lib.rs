mod intcode;
mod ascii_code;

pub mod day_01; pub mod day_02; pub mod day_03; pub mod day_04; pub mod day_05; pub mod day_06; pub mod day_07; 
pub mod day_08; pub mod day_09; pub mod day_10; pub mod day_11; pub mod day_12; pub mod day_13; pub mod day_14; 
pub mod day_15; pub mod day_16; pub mod day_17; pub mod day_18; pub mod day_19; pub mod day_20; pub mod day_21; 
pub mod day_22; pub mod day_23; pub mod day_24; pub mod day_25; 

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
#[test] fn day_16() { assert_eq!(day_16::run(), (27229269, 26857164)); }
#[test] fn day_17() { assert_eq!(day_17::run(), (6244, 1143523)); }
#[test] fn day_18() { assert_eq!(day_18::run(), (6316, 1648)); }
#[test] fn day_19() { assert_eq!(day_19::run(), (203, 8771057)); }
#[test] fn day_20() { assert_eq!(day_20::run(), (458, 5502)); }
#[test] fn day_21() { assert_eq!(day_21::run(), (19353565, 1140612950)); }
#[test] fn day_22() { assert_eq!(day_22::run(), (1234, 7757787935983)); }
#[test] fn day_23() { assert_eq!(day_23::run(), (18192, 10738)); }
#[test] fn day_24() { assert_eq!(day_24::run(), (3186366, 2031)); }
#[test] fn day_25() { assert_eq!(day_25::run(), (278664, 0)); }
