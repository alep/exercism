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
  let p0 = pathfinder([#(tree, [])], from, set.new())
  case p0 {
    [] -> Error(Nil)
    _ -> Ok(  treepath([#(tree, [])], from, set.new()))
  }
}

pub fn path_to(
  tree tree: Tree(a),
  from from: a,
  to to: a,
) -> Result(List(a), Nil) {
  // build a graph representation
  //  let graph = bfs([tree], dict.new())
  // debug(graph)
  // case find([from], graph, to, set.new(), []) |> list.reverse {
  //  [] -> Error(Nil)
  //  [from, to] -> Error(Nil)
  //  v -> Ok(v)
  // }
  let p0 = pathfinder([#(tree, [])], from, set.new())
  let p1 = pathfinder([#(tree, [])], to, set.new())
  case p0, p1 {
    [], [] -> Error(Nil)
    [], _ -> Error(Nil)
    _, [] -> Error(Nil)
    _, _ ->
    match(p0 |> list.reverse(), p1 |> list.reverse(), [])
  }
}

fn update(graph: Dict(a, Set(a)), from: a, to: a) -> Dict(a, Set(a)) {
  graph |> dict.upsert(from, fn(value) {
    let new = set.from_list([to])
    case value {
      None -> new
      Some(neighbors) -> neighbors |> set.union(new)
    }
  })
}

fn update_many(graph: Dict(a, Set(a)), from: a, to: List(a)) -> Dict(a, Set(a)) {
  graph |> dict.upsert(from, fn(value) {
    let new = set.from_list(to)
    case value {
      None -> new
      Some(neighbors) -> { neighbors |> set.union(new) }
    }
  })
}

fn bfs(queue: List(Tree(a)), graph: Dict(a, Set(a))) -> Dict(a, Set(a)) {
  case queue {
    [] -> graph
    [t, ..rest] -> {
      case t {
        Tree(label, []) -> {
          bfs(rest, graph)
        }
        Tree(label, children) -> {
          let graph = graph |> update_many(label, children |> list.map(fn(t) { t.label }))
          let graph = children |> list.fold(graph, fn(graph, elem) {
            update(graph, elem.label, label)
          })
          bfs(list.append(rest, children), graph)
        }
      }
    }
  }
}

fn find(queue: List(a), graph: Dict(a, Set(a)), to: a, visited: Set(a), path: List(a)) -> List(a) {
  case queue {
    [] -> path
    [label, ..rest] if label == to -> {
        [label, ..path]
    }
    [label, ..rest] -> {
      case visited |> set.contains(label) {
        True -> {find(rest, graph, to, visited, path)}
        False -> {
          let neighbors = graph |> dict.get(label) |> result.unwrap(set.new()) |> set.difference(visited) |> set.to_list()
          case neighbors {
              [] -> find(rest, graph, to, visited |> set.insert(label), path)
               v ->
          find(list.append(rest, neighbors), graph, to, visited |> set.insert(label), [label, ..path])
          }
        }
      }
    }
  }
}

fn removeprev(forest: List(Tree(a))) -> Tree(a) {
    debug("forest")
    debug(forest)
    let r = case forest {
      [] -> { panic as "not defined" }
      [t] -> { t }
      [Tree(parent, children0), Tree(child, children1), ..rest] -> {
        removeprev([Tree(child, list.prepend(children1, Tree(parent, children0))), ..rest])
      }
    }
    debug(r)
}

fn treepath(stack: List(#(Tree(a), List(Tree(a)))), label: a, visited: Set(a)) -> Tree(a) {
  case stack {
    [] -> panic as "not defined!"
    [#(t, path), ..rest] -> {
      case visited |> set.contains(t.label) { 
        True -> { treepath(rest, label, visited) }
        False -> case t {
            Tree(t0, []) if t0 != label -> treepath(rest, label, visited |> set.insert(t0))
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
                    treepath(list.append(neighbors, stack), label, visited |> set.insert(t0)) 
                  }
                  [parent, ..rest] -> {
                    let parent = Tree(parent.label, parent.children |> list.filter(fn(t) { t.label != t0 }))
                    let neighbors = children |> list.map(fn(elem) { #(elem, [t, parent, ..rest]) })
                    treepath(list.append(neighbors, stack), label, visited |> set.insert(t0)) 
                  }
              }
              
          }
        }
      }
    }
  }
}

fn pathfinder(stack: List(#(Tree(a), List(a))), label: a, visited: Set(a)) -> List(a) {
  case stack {
    [] -> []
    [#(t, path), ..rest] -> {
      case visited |> set.contains(t.label) { 
        True -> { pathfinder(rest, label, visited) }
        False -> case t {
            Tree(t0, _) if t0 == label -> [label, ..path]
            Tree(t0, []) if t0 != label -> pathfinder(rest, label, visited |> set.insert(t0))
            Tree(t0, children) -> {
              let neighbors = children |> list.map(fn(elem) { #(elem, [t0, ..path])  })
              pathfinder(list.append(neighbors, stack), label, visited |> set.insert(t0)) 
          }
        }
      }
    }
  }
}

fn match(l: List(a), m: List(a), last: List(a)) -> Result(List(a), Nil) {
  case l, m {
    [], [] -> Error(Nil)
    [], [h1, ..m0] -> Ok(last |> list.append(m))
    [h0, ..l0], [] -> Ok(l |> list.append(last))

    [h0, ..l0], [h1, ..m0] -> case h0 == h1 {
      True -> { match(l0, m0, [h0]) }
      False -> { 
        Ok(l |> list.reverse() |> list.append(last) |> list.append(m))     
      }
    }
  }
}



