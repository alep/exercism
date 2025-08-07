import gleam/list
import gleam/dict.{type Dict}
import gleam/set.{type Set}
import gleam/result
import gleam/option.{type Option, None, Some}
import exercism/test_runner.{ debug }

pub type Tree(a) {
  Tree(label: a, children: List(Tree(a)))
}

pub fn from_pov(tree: Tree(a), from: a) -> Result(Tree(a), Nil) {
  let p0 = pathfinder([#(tree, [])], from)
  case p0 {
    [] -> Error(Nil)
    _ -> Ok(  treepath([#(tree, [])], from))
  }
}

pub fn path_to(
  tree tree: Tree(a),
  from from: a,
  to to: a,
) -> Result(List(a), Nil) {
  let p0 = pathfinder([#(tree, [])], from)
  let p1 = pathfinder([#(tree, [])], to)
  case p0, p1 {
    [], [] -> Error(Nil)
    [], _ -> Error(Nil)
    _, [] -> Error(Nil)
    _, _ ->
    match(p0 |> list.reverse(), p1 |> list.reverse(), [])
  }
}


fn removeprev(forest: List(Tree(a))) -> Tree(a) {
    let r = case forest {
      [] -> { panic as "not defined" }
      [t] -> { t }
      [Tree(parent, children0), Tree(child, children1), ..rest] -> {
        removeprev([Tree(child, list.prepend(children1, Tree(parent, children0))), ..rest])
      }
    }
    debug(r)
}

fn treepath(stack: List(#(Tree(a), List(Tree(a)))), label: a) -> Tree(a) {
  case stack {
    [] -> panic as "not defined!"
    [#(t, path), ..rest_stack] -> {
 case t {
            Tree(t0, []) if t0 != label -> treepath(rest_stack, label)
            Tree(t0, children) if t0 == label -> {
                case path {
                  [] -> {
                      t
                  }
                  [parent, ..rest] -> {
                      let parent = Tree(parent.label, parent.children |> list.filter(fn(t) { t.label != t0 }))
                      removeprev([t, parent, ..rest] |> list.reverse())
                  }
              }
            }
            Tree(t0, children) -> {
              case path {
                  [] -> {
                    let neighbors = children |> list.map(fn(elem) { #(elem, [t]) })
                    treepath(list.append(neighbors, rest_stack), label) 
                  }
                  [parent, ..rest] -> {
                    let parent = Tree(parent.label, parent.children |> list.filter(fn(t) { t.label != t0 }))
                    let neighbors = children |> list.map(fn(elem) { #(elem, [t, parent, ..rest]) })
                    treepath(list.append(neighbors, rest_stack), label) 
                  }
              }
              
          }
        }
      }
    }
  }


fn pathfinder(stack: List(#(Tree(a), List(a))), label: a) -> List(a) {
  case stack {
    [] -> []
    [#(t, path), ..rest] -> {
        case t {
            Tree(t0, _) if t0 == label -> [label, ..path]
            Tree(t0, []) if t0 != label -> pathfinder(rest, label)
            Tree(t0, children) -> {
              let neighbors = children |> list.map(fn(elem) { #(elem, [t0, ..path])  })
              pathfinder(list.append(neighbors, rest), label) 
          }
        }
      }
    }
  }

fn match(l: List(a), m: List(a), last: List(a)) -> Result(List(a), Nil) {
  case l, m {
    [], [] -> Error(Nil)
    [], [_h1, ..m0] -> Ok(last |> list.append(m))
    [_h0, .._l0], [] -> Ok(l |> list.append(last))

    [h0, ..l0], [h1, ..m0] -> case h0 == h1 {
      True -> { match(l0, m0, [h0]) }
      False -> { 
        Ok(l |> list.reverse() |> list.append(last) |> list.append(m))     
      }
    }
  }
}



