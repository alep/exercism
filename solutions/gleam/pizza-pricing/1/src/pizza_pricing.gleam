pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

fn price(pizza: Pizza, acc: Int) -> Int {
  case pizza {
    Margherita ->  7 + acc
    Caprese -> 9 + acc 
    Formaggio -> 10 + acc
    ExtraSauce(pi) -> price(pi, acc + 1)
    ExtraToppings(pi) -> price(pi, acc + 2)
  }
}

pub fn pizza_price(pizza: Pizza) -> Int {
  price(pizza, 0)
}

fn ord(order: List(Pizza), acc: Int, len: Int) -> Int {
  case order, len {
    [], 0 -> 0
    [], 1 -> acc + 3
    [], 2 -> acc + 2
    [], _ -> acc
    [pi, ..rest], len -> ord(rest, acc + pizza_price(pi), len + 1)
  } 
}

pub fn order_price(order: List(Pizza)) -> Int {
  case order {
    [] -> 0
    _ -> ord(order, 0, 0)
  }
}
