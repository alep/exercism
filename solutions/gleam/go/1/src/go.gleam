import gleam/result
import exercism/test_runner.{ debug }

pub type Player {
  Black
  White
}

pub type Game {
  Game(
    white_captured_stones: Int,
    black_captured_stones: Int,
    player: Player,
    error: String,
  )
}

fn checked_apply(game: Game, start: Game, rule: fn(Game) -> Result(Game, String)) ->  Game {
  debug(game)
  case game {
    Game(_, _, _, "") -> {
        let new_game =  game |> rule 
               |> result.map_error(with: fn(reason) { Game(..start, error: reason) }) 
               |> result.unwrap_both
        debug(new_game)
        new_game
}
    Game(_, _, _, _) -> game
  }  
}

fn apply(game: Game, start: Game, rule: fn(Game) -> Game) -> Game {
  case game {
    Game(_, _, _, "") -> rule(game)
    Game(_, _, _, _) -> game
  }
}

pub fn apply_rules(
  game: Game,
  rule1: fn(Game) -> Result(Game, String),
  rule2: fn(Game) -> Game,
  rule3: fn(Game) -> Result(Game, String),
  rule4: fn(Game) -> Result(Game, String),
) -> Game {
  let start = game

  let new_game = game |> checked_apply(start, rule1)
       |> apply(start, rule2)
       |> checked_apply(start, rule3)
       |> checked_apply(start, rule4)

  case new_game {
    Game(_, _, _, "") -> Game(..new_game, player: Black, error: "")
    Game(_, _, _, _) -> new_game
  }

}
