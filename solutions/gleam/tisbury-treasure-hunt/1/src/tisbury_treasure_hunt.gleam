import gleam/list

pub fn place_location_to_treasure_location(
  place_location: #(String, Int),
) -> #(Int, String) {
  let #(x, y) = place_location
  #(y, x)
}

pub fn treasure_location_matches_place_location(
  place_location: #(String, Int),
  treasure_location: #(Int, String),
) -> Bool {
  place_location_to_treasure_location(place_location) == treasure_location
}

pub fn count_place_treasures(
  place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  let filter = fn (other_place) -> Bool { 
      let #(_other_name, other_location) = other_place
      let #(_name, place_location) = place
      treasure_location_matches_place_location(place_location, other_location)
    } 
  treasures |> list.count(filter)
}

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  let #(found_name, _found_location) = found_treasure
  let #(place_name, _place_location) = place
  let #(desired_name, _desired_location) = desired_treasure

  case found_name, place_name, desired_name {
    "Brass Spyglass", "Abandoned Lighthouse", _ -> True
    "Amethyst Octopus", "Stormy Breakwater", "Glass Starfish" -> True
    "Amethyst Octopus", "Stormy Breakwater", "Crystal Crab"  -> True
    "Vintage Pirate Hat", "Harbor Managers Office", "Model Ship in Large Bottle",  -> True
    "Vintage Pirate Hat", "Harbor Managers Office", "Antique Glass Fishnet Float"  -> True
    _, _, _ -> False
  }
}
