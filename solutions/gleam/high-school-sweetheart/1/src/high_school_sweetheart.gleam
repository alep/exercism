import gleam/string
import gleam/result

pub fn first_letter(name: String) -> String {
  name |> string.trim 
       |> string.first 
       |> result.unwrap("") 
}

pub fn initial(name: String) -> String {
  let dot = fn(x) { x <> "." }
  name |> first_letter |> string.capitalise |> dot
}

pub fn initials(full_name: String) -> String {
  let #(fst, snd) = string.split_once(full_name, " ") |> result.unwrap(#("", ""))
  let i = initial(fst) <> " " <> initial(snd) 
  i
}

pub fn pair(full_name1: String, full_name2: String) {
  "
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **" 
  <>
  "
**     " <> initials(full_name1) <> "  +  " <> initials(full_name2) <> "     **" <>
"
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
"
}
