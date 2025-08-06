pub fn today(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [n, ..rest] -> n
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
    case days {
      [] -> [1]
      [n, ..rest] -> [n+1, ..rest]
    }
}

fn no_birds(days: List(Int)) -> Bool {
    case days {
      [] -> False
      [0, .._rest] -> True
      [n, ..rest] -> no_birds(rest)
    } 
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  no_birds(days)
}

fn s(days: List(Int), acc: Int) -> Int {
  case days {
    [] -> acc
    [n, ..rest] -> s(rest, acc + n)
  }
}

pub fn total(days: List(Int)) -> Int {
  s(days, 0)
}

fn b(days: List(Int), acc: Int) -> Int {
  case days {
    [] -> acc
    [n, ..rest] if n >= 5 -> b(rest, acc + 1)
    [_n, ..rest] -> b(rest, acc)
  }
}

pub fn busy_days(days: List(Int)) -> Int {
  b(days, 0)
}
