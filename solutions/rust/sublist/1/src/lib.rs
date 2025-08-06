#[derive(Debug, PartialEq, Eq)]
pub enum Comparison {
    Equal,
    Sublist,
    Superlist,
    Unequal,
}
fn is_sublist<T: PartialEq>(xs: &[T], ys: &[T]) -> bool {
    for window in xs.windows(ys.len()) {
        if window.eq(ys) {
            return true;
        }
    }
    return false;

}

pub fn sublist<T: PartialEq>(xs: &[T], ys: &[T]) -> Comparison {
    if xs.is_empty() && ys.is_empty() {
        return Comparison::Equal;
    } else if ys.is_empty() {
        return Comparison::Superlist;
    } else if xs.is_empty() {
        return Comparison::Sublist;
    }
    
    if xs.len() < ys.len() {
         if is_sublist(ys, xs) {
             return Comparison::Sublist;
         } else {
             return Comparison::Unequal;
         }
     }  else if is_sublist(xs, ys) {
         if xs.len() == ys.len() {
             return Comparison::Equal;
         } else {
            return Comparison::Superlist;
         } 
     } else {
         return Comparison::Unequal;
     }
}
