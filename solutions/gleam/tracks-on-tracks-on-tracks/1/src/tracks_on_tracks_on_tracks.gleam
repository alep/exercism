import gleam/list
import gleam/result

pub fn new_list() -> List(String) {
  []
}

pub fn existing_list() -> List(String) {
  ["Gleam", "Go", "TypeScript"]
}

pub fn add_language(languages: List(String), language: String) -> List(String) {
  [language, ..languages]
}

pub fn count_languages(languages: List(String)) -> Int {
  list.length(languages)
}

fn rev(lang: List(String), acc: List(String)) -> List(String) {
  case lang {
    [] -> acc
    [head, ..rest] -> rev(rest, list.append([head], acc))
  }
}

pub fn reverse_list(languages: List(String)) -> List(String) {
  rev(languages, [])
}

 
pub fn exciting_list(languages: List(String)) -> Bool {
  let count = count_languages(languages)
  case languages {
    ["Gleam", ..rest] -> True
    [_first, "Gleam", ..rest] if count < 4 -> True
    _ -> False
}
}
