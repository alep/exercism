import gleam/dict.{type Dict}
import gleam/result

pub type ScoreBoard =
  Dict(String, Int)

pub fn create_score_board() -> ScoreBoard {
	dict.from_list([#("The Best Ever", 1_000_000)])
}

pub fn add_player(
  score_board: ScoreBoard,
  player: String,
  score: Int,
) -> ScoreBoard {
	score_board |> dict.insert(player, score)
}

pub fn remove_player(score_board: ScoreBoard, player: String) -> ScoreBoard {
	score_board |> dict.delete(player)	

}

fn update(score_board: ScoreBoard, player: String, points: Int) -> ScoreBoard {
	score_board |> remove_player(player)
		    |> add_player(player, points)
}


pub fn update_score(
  score_board: ScoreBoard,
  player: String,
  points: Int,
) -> ScoreBoard {
  	score_board |> dict.get(player)
		    |> result.try(fn(score) { Ok(score_board |> update(player, score + points)) })
		    |> result.map_error(fn(_err) {score_board})
		    |> result.unwrap_both
}

pub fn apply_monday_bonus(score_board: ScoreBoard) -> ScoreBoard {
	score_board |> dict.map_values(fn(_player,points) {points + 100})
}
