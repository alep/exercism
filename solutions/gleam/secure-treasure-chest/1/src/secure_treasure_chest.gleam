import gleam/string

// Please define the TreasureChest type
pub opaque type TreasureChest(a) {
  TreasureChest(String, a)
}

pub fn create(
  password: String,
  contents: treasure,
) -> Result(TreasureChest(treasure), String) {
  case string.length(password) >= 8 {
      False -> Error("Password must be at least 8 characters long")
      True -> Ok(TreasureChest(password, contents))
  }
}

pub fn open(
  chest: TreasureChest(treasure),
  password: String,
) -> Result(treasure, String) {
    case chest {
      TreasureChest(pass, contents) if pass == password -> Ok(contents)
      _ -> Error("Incorrect password")
    }
}
