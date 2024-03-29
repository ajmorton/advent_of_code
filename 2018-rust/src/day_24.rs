use regex::Regex;
use std::collections::HashMap;

#[derive(Debug, Clone, Copy, PartialEq)]
enum UnitType {Infection, Immune}
#[derive(Debug, Clone)]
struct Units {
    id: usize,
    unit_type: UnitType,
    num_units: isize,
    hit_points: isize,
    immunities: Vec<&'static str>,
    weaknesses: Vec<&'static str>,
    attack_power: isize,
    attack_type: String,
    initiative: isize,
}

impl Units {
    const fn effective_power(&self) -> isize {
        self.num_units * self.attack_power
    }

    fn vulnerability_modifier(&self, attack_type: &str) -> isize {
        if self.immunities.contains(&attack_type) {
            0
        } else if self.weaknesses.contains(&attack_type) {
            2
        } else {
            1
        }
    }

    fn inflict_damage(&mut self, attack_power: isize, attack_type: &str) {
        let damage = attack_power * self.vulnerability_modifier(attack_type);
        let num_killed = isize::min(self.num_units, damage / self.hit_points);
        self.num_units -= num_killed;
        // println!("\t{} damage done to {:?} {}, leaving {} units (deaths = {})", damage, self.unit_type, self.id, self.num_units, num_killed);
    }
}

fn create_units(lines: &[&'static str], unit_type: UnitType) -> Vec<Units> {
    let mut units = vec![];
    lazy_static! {
        static ref UNIT_REGEX: Regex = Regex::new(r"(\d+) units each with (\d+) hit points((?: \().*\))? with an attack that does (\d+) (\w+) damage at initiative (\d+)").unwrap();
        static ref IMMUNE_REGEX: Regex = Regex::new(r"immune to ([a-z]+)(?:, ([a-z]+))?(?:, ([a-z]+))?").unwrap();
        static ref WEAK_REGEX: Regex = Regex::new(r"weak to ([a-z]+)(?:, ([a-z]+))?(?:, ([a-z]+))?").unwrap();
    }

    for (id, line) in lines.iter().skip(1).enumerate() {
        let caps = UNIT_REGEX.captures(line).unwrap();
        let num_units = caps[1].parse::<isize>().unwrap();
        let hit_points = caps[2].parse::<isize>().unwrap();
        // modifiers = caps[3]
        let attack_power = caps[4].parse::<isize>().unwrap();
        let attack_type = caps[5].to_string();
        let initiative = caps[6].parse::<isize>().unwrap();

        let mut immunities = vec![];
        let mut weaknesses = vec![];

        if let Some(modifiers) = caps.get(3) {
            if let Some(immunities_cap) = IMMUNE_REGEX.captures(modifiers.as_str()) {
                immunities = immunities_cap.iter().skip(1).filter_map(|imm| {
                    imm.map(|imm| imm.as_str().trim_matches(|c| " ,".contains(c)))
                }).collect();
            }

            if let Some(weaknesses_cap) = WEAK_REGEX.captures(modifiers.as_str()) {
                weaknesses = weaknesses_cap.iter().skip(1).filter_map(|imm| {
                    imm.map(|imm| imm.as_str().trim_matches(|c| " ,".contains(c)))
                }).collect();
            }

        }

        units.push(Units{id, unit_type, num_units, hit_points, immunities, weaknesses, attack_power, attack_type, initiative});
    }
    units
}

fn allocate_targets(units: &mut Vec<Units>, enemies: &[Units]) -> HashMap<usize, usize> {
    units.sort_by_key(|unit| (-unit.effective_power(), -unit.initiative));
    let mut targets = HashMap::new();
    for attacker in units {
        // println!("Deciding for {:?} {} (ep: {})", attacker.unit_type, attacker.id + 1, attacker.effective_power());
        let not_attacked = enemies.iter().filter(|&enemy| {
            !targets.values().any(|target| *target == enemy.id)
        });

        if let Some(target) = not_attacked.filter(|&enemy| enemy.vulnerability_modifier(&attacker.attack_type) != 0).max_by_key(|&enemy| 
            (enemy.vulnerability_modifier(&attacker.attack_type), enemy.effective_power(), enemy.initiative)
        ){
            targets.insert(attacker.id, target.id);
            // println!("allocating {:?} {} to {:?} {}", target.unit_type, target.id + 1, attacker.unit_type, attacker.id+1);
        } else {
            // println!("can't find anything for {:?} {}", attacker.unit_type, attacker.id+1);
        }
    }

    targets
}

fn attack(attacker_ref: &Units, targets: &HashMap<usize, usize>, units: &[Units], enemies: &mut Vec<Units>) {
    if targets.contains_key(&attacker_ref.id) {
        let attacker = units.iter().find(|attacker| attacker.id == attacker_ref.id).unwrap();
        if attacker.num_units <= 0 {
            return;
        }
        if let Some(target) = enemies.iter_mut().find(|enemy| enemy.id == targets[&attacker_ref.id]) {
            // print!("{:?} {} attacks {:?} {} {} num: {} atk: {}\t", attacker_ref.unit_type, attacker_ref.id + 1, target.unit_type, target.id + 1, attacker.num_units, attacker.num_units, attacker.attack_power);
            target.inflict_damage(attacker.effective_power(), &attacker_ref.attack_type);
        }
    }
}

fn fight(immune_system: &[Units], infections: &[Units]) -> Option<(UnitType, isize)> {
    let mut immune_system: Vec<Units> = immune_system.to_owned();
    let mut infections: Vec<Units> = infections.to_owned();

    let mut total_units_last_round = 0;
    let mut num_groups_last_round = 0;

    loop {
        immune_system = immune_system.into_iter().filter(|unit| unit.num_units > 0).collect();
        infections = infections.into_iter().filter(|unit| unit.num_units > 0).collect();

        let total_units = immune_system.iter().map(|unit| unit.num_units).sum::<isize>()
            + infections.iter().map(|unit| unit.num_units).sum::<isize>();

        let num_groups = immune_system.len() + infections.len();
        if num_groups == num_groups_last_round && total_units == total_units_last_round {
            return None; // stalemate
        } else if immune_system.is_empty() {
            return Some((UnitType::Infection, infections.iter().map(|inf| inf.num_units).sum()));
        } else if infections.is_empty() {
            return Some((UnitType::Immune, immune_system.iter().map(|imm| imm.num_units).sum()));
        }

        total_units_last_round = total_units;
        num_groups_last_round = num_groups;

        // targeting phase
        let immune_targets = allocate_targets(&mut immune_system, &infections);
        let infection_targets = allocate_targets(&mut infections, &immune_system);

        // attack phase
        let immune_copy = immune_system.to_owned();
        let infection_copy = infections.to_owned();
        let mut all_units: Vec<&Units> = immune_copy.iter().chain(infection_copy.iter()).collect();
        all_units.sort_by_key(|unit| -unit.initiative);

        for unit_ref in all_units {
            if unit_ref.unit_type == UnitType::Immune {
                attack(unit_ref, &immune_targets, &immune_system, &mut infections);
            } else {
                attack(unit_ref, &infection_targets, &infections, &mut immune_system);
            }
        }
        // println!();
    }
}

#[must_use]
pub fn run() -> (isize, isize) {
    let input: Vec<&str> = include_str!("../input/day24.txt").trim_end_matches('\n').split("\n\n").collect();

    let immune_system: Vec<&str> = input[0].split('\n').collect();
    let infections: Vec<&str> = input[1].split('\n').collect();

    let immune_system = create_units(&immune_system, UnitType::Immune);
    let infections = create_units(&infections, UnitType::Infection);

    // p1
    let (_winner, p1) = fight(&immune_system, &infections).unwrap();

    // p2
    let mut boost = 1;
    let p2;
    loop {
        let boosted_immune = immune_system.clone().iter().map(|unit| {
            let mut boosted_unit = unit.clone(); 
            boosted_unit.attack_power += boost; 
            boosted_unit
        }).collect::<Vec<_>>();

        // println!("{}\t {:?}", boost, fight(&boosted_immune, &infections));
        if let Some((winner, num_winning_units)) = fight(&boosted_immune, &infections) {
            if winner == UnitType::Immune {
                p2 = num_winning_units;
                break;
            }
        }

        boost += 1;
    }

    // debug later
    (p1, p2)
}

#[test]
fn day_24() {
    assert_eq!(run(), (21765, 5522));
}
