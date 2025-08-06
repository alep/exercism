import gleam/dict
import gleam/list
import gleam/int
import gleam/order
import gleam/result
import gleam/string


pub fn parse_loop(s: String, acc: List(String)) -> List(String) {
  case s {
     "" -> acc
     "_" <> rest -> parse_loop(rest, [" ", ..acc])
     " " <> rest -> parse_loop(rest, [" ", ..acc])
     "*" <> rest -> parse_loop(rest, ["*", ..acc])
    _ -> panic as "no other pattern should be present"
  }
}

pub fn parse(s: String) -> List(String) {
  parse_loop(s, [])
}

fn mine_row(mines: List(Int)) -> String {
  case mines {
    [] -> ""
    [0 ..rest] -> "_" <> mine_row(rest)
    [-1 ..rest] -> "*" <> mine_row(rest)
    [n ..rest] -> int.to_string(n) <> mine_row(rest)
  }
}

fn minefield_(mines: List(List(Int))) -> String {
  mines
    |> list.map(mine_row)
    |> string.join("\n")
}

pub fn neighbours(pos: #(Int, Int)) -> List(#(Int, Int)) {
  let n =  [#(-1, -1), #(-1, 0), #(-1, 1),
            #(0, -1),            #(0,  1),
            #(1, -1),  #(1,  0), #(1,  1)]
  list.map(n, fn(x: #(Int, Int)) { #(x.0 + pos.0, x.1 + pos.1)})
}

pub fn compare(a: #(Int, Int), b: #(Int, Int)) -> order.Order {
  case int.compare(a.0, b.0) {
    order.Eq -> int.compare(a.1, b.1)
    x -> x
  }
}


pub fn annotate(minefield: String) -> String {
  let str = minefield
  let my_test_list = list.map(string.split(str, "\n"), fn(ls) { ls |> parse |> list.reverse })
  let shit_with_stars = list.filter_map(
      list.flatten(
        list.index_map(
          my_test_list, 
          fn(l, j) { 
            list.index_map(l, fn(x, i) { #(#(i, j), x) }) 
          }
        )
      ),
      fn (x) { case x.1 == "*" { True -> Ok(x.0) False -> Error(Nil) }}
    )


  let d = dict.map_values(list.group(list.sort(
    list.flat_map(shit_with_stars, neighbours), 
    by: compare),
    by: fn(i) {i}
    ), fn(_k, v) { list.length(v)})
  let result = list.map(  
      list.index_map(
          my_test_list, 
          fn(l, j) { 
            list.index_map(l, fn(x, i) { #(#(i, j), x) }) 
          }
        ),
      list.map(_, fn (x:#(#(Int, Int), String)) {
                    case x.1 == " " { 
                      True -> result.unwrap(dict.get(d, x.0), 0)
                      False -> case x.1 == "*" { True -> -1 False ->0 } 
                    }
                  })
  )

  minefield_(result)
}
