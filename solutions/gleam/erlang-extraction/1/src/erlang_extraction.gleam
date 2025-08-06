// Please define the GbTree type
pub type GbTree(key, value)  // key and value are type parameters

@external(erlang, "gb_trees", "empty")
pub fn new_gb_tree() -> GbTree(k, v)

@external(erlang, "gb_trees", "insert")
fn internal_insert(key: k, value: v, tree: GbTree(k, v)) -> GbTree(k, v)

pub fn insert(tree: GbTree(k, v), key: k, value: v) -> GbTree(k, v) {
  internal_insert(key, value, tree)
}


@external(erlang, "gb_trees", "delete_any")
fn internal_delete(key: k, tree: GbTree(k, v)) -> GbTree(k, v)

pub fn delete(tree: GbTree(k, v), key: k) -> GbTree(k, v) {
  internal_delete(key, tree)
}