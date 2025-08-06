import gleam/string

pub fn extract_error(problem: Result(a, b)) -> b {
  let assert Error(description) = problem
  description
}

pub fn remove_team_prefix(team: String) -> String {
  let assert "Team " <> suffix = team 
  suffix
}

pub fn split_region_and_team(combined: String) -> #(String, String) {
  let assert [region, team] = string.split(combined, ",")
  #(region, remove_team_prefix(team))
}
