import gleam/set.{type Set, filter, size, union, to_list, from_list, insert, contains, delete, fold}
import gleam/list.{reduce, map, length, fold as list_fold, flat_map}

import gleam/pair.{second}
import gleam/string.{starts_with}
import gleam/option.{Some, None}
import gleam/dict

pub fn new_collection(card: String) -> Set(String) {
	from_list([card])
}

pub fn add_card(collection: Set(String), card: String) -> #(Bool, Set(String)) {
	case contains(collection, card) {
		True -> #(True, collection)
		False -> #(False, collection |> insert(card))
	}
}

pub fn trade_card(
  my_card: String,
  their_card: String,
  collection: Set(String),
) -> #(Bool, Set(String)) {
	case contains(collection, my_card), contains(collection, their_card) {
		True, False -> #(True, collection |> delete(my_card) |> add_card(their_card) |> second ) 
		True, True -> #(False, collection |> delete(my_card))
		False, _ -> #(False, collection |> add_card(their_card) |> second )
	}
}


fn reducer(acc: dict.Dict(String, Int), member: String) -> dict.Dict(String, Int) {
	dict.upsert(acc, member, fn(opt) {
		case opt {
			Some(v) -> v + 1
			None -> 1
		}
	})
}

fn dict_reducer(acc: dict.Dict(String, Int), member: dict.Dict(String, Int)) -> dict.Dict(String, Int) {
	dict.combine(acc, member, fn(value, other_value) { value + other_value})
}

pub fn boring_cards(collections: List(Set(String))) -> List(String) {
	let num = length(collections)

	collections |> flat_map(to_list)
	            |> list_fold(dict.from_list([]), reducer)
		    |> dict.filter(fn(_k, value) { value == num })
	            |> dict.keys()

}

pub fn total_cards(collections: List(Set(String))) -> Int {
	collections |> list_fold(from_list([]), union)
		    |> size 		
}

pub fn shiny_cards(collection: Set(String)) -> Set(String) {
 	collection |> filter(fn(member) { starts_with(member, "Shiny " )}) 
}
