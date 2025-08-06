import gleam/int

pub fn reply(guess: Int) -> String {
  case guess {
    42 -> "Correct"
    41 | 43 -> "So close"
    n if n < 41 -> "Too low"
    n if n > 43 -> "Too high"
    _ -> panic
  }
}
