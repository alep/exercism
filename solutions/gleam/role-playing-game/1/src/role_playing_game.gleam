import gleam/option.{type Option, Some, None}

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  case player.name {
    Some(value) -> value
    None -> "Mighty Magician"
  }
}
  
fn mana_level(level: Int, mana: Option(Int)) -> Option(Int) {
    case level >= 10 {
      True -> Some(100)
      False -> mana
    }
}


pub fn revive(player: Player) -> Option(Player) {
  case player {
    Player(name, level, health, mana) if health == 0 -> Some(Player(name, level, 100, mana_level(level, mana)))
    _ -> None
  }
}

fn decrease_health(health: Int, decrease: Int) -> Int {
  let new_health_level = health - decrease
  case new_health_level > 0 {
    True -> new_health_level
    False -> 0
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  case player.health == 0 {
    True -> #(player, 0)
    False -> {  
      case player.mana {
        Some(value) if value >= cost -> #(Player(..player, mana: Some(value - cost)), cost * 2)
        Some(_) -> #(player, 0)
        None -> #(Player(..player, health: decrease_health(player.health, cost)), 0)
      }
    }
  }
}
