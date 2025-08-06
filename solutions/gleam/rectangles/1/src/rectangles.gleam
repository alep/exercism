import gleam/result
import gleam/order.{type Order, Lt, Gt}
import gleam/string
import gleam/set
import gleam/int
import gleam/list
import gleam/dict.{type Dict}
import gleam/pair





//    "  0\0(x-axis) cols ->    
// (y-axis)+----+
// rows |  |    |
//      |  |    |
//      v  +----+
//    "

// Completely counterintuitive, but the row number is y axis
pub fn row(row_index: Int, ncols: Int) -> List(#(Int, Int)) {
  list.zip(list.range(from: 0, to: ncols), list.repeat(row_index, ncols),)
}

pub fn col(s: String, row_index: Int) -> List(#(#(Int, Int), String)) {
  let ncols = string.length(s)
  let chars = s |> string.to_graphemes
  list.zip(row(row_index, ncols), chars)
}

pub fn parse(s: String) -> Dict(#(Int, Int), String){
   	let s = s |> string.split("\n")
   
	s |> list.index_map(fn(x, i) { col(x, i)})
	  |> list.flatten()
    	  |> list.filter(fn(tuple) { ! { " " == pair.second(tuple) } })
    	  |> dict.from_list()
}

fn cmp(point: #(Int, Int), other_point: #(Int, Int)) -> Order {
	let #(x, y) = point
	let #(a, b) = other_point

	case x - a {
		n if n < 0 ->  { Lt }  
		n if n == 0 -> { int.compare(y, b) }
		n if n > 0 -> { Gt}
		_ -> { panic as "This should not happen." } 
	}
}


fn check_rectangle(points: List(#(Int, Int))) -> Bool {
	let assert [a, b, c, d] = points |> list.sort(by: cmp)


	let #(a_x, a_y) = a
	let #(b_x, b_y) = b
	let #(c_x, c_y) = c
	let #(d_x, d_y) = d

	let r = { a_x == b_x } && { c_x == d_x } && { a_y  == c_y } && { b_y == d_y }
	r
}

fn line(current: #(Int, Int), end: #(Int, Int), board: Dict(#(Int, Int), String), dir: #(#(Int, Int), String)) -> Bool {
	let r = case current == end {

		True -> True
		False -> {
			let #(#(dx, dy), s) = dir
			case board |> dict.get(current) {
				Error(_) -> False
				Ok(v) if v == s || v == "+"  -> {
					let #(x, y) = current

					line(#(x + dx, y + dy), end, board, dir)
				}
				Ok(_) -> { False }
			}
		}
	}
	r
}

fn up(current: #(Int, Int), end: #(Int, Int), board: Dict(#(Int, Int), String)) -> Bool {
	line(current, end, board, #(#(0, -1), "|"))
}

fn down(current: #(Int, Int), end: #(Int, Int), board: Dict(#(Int, Int), String)) -> Bool {
	line(current, end, board, #(#(0, 1), "|"))
}

fn right(current: #(Int, Int), end: #(Int, Int), board: Dict(#(Int, Int), String)) -> Bool {
	line(current, end, board, #(#(1, 0), "-"))
}

fn left(current: #(Int, Int), end: #(Int, Int), board: Dict(#(Int, Int), String)) -> Bool {
	line(current, end, board, #(#(-1, 0), "-"))
}

fn cycle(points: List(#(Int, Int)), board: Dict(#(Int, Int), String)) -> Bool {
	let assert [a, b, c, d] = points
	down(a, b, board) && right(b, d, board) && up(d, c, board) && left(c, a, board) 
}

fn is_rectangle(points: List(#(Int, Int)), board: Dict(#(Int, Int), String)) -> Result(List(#(Int, Int)), Nil) {
	case points |> check_rectangle && points |> cycle(board) {
		True -> Ok(points)
		False -> Error(Nil)
	}
}



pub fn rectangles(input: String) -> Int {
	let board = parse(input) 

	let rects = board 	|> dict.filter(fn(_k, v) { v == "+" })
		|> dict.keys()
		|> list.combinations(4)
		|> list.map(fn(c) { c |> is_rectangle(board) })
		|> list.filter(fn(r) { result.is_ok(r)} )
		
	rects |> set.from_list()
	      |> set.size()
	

}




