/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    let mut number : Vec<i64> = vec![];
    for c in code.chars() {
       let n = match c {
            '0' => 0,
            '1' => 1,
            '2' => 2,
            '3' => 3,
            '4' => 4,
            '5' => 5,
            '6' => 6,
            '7' => 7,
            '8' => 8,
            '9' => 9,
            ' ' => continue,
            _ => return false
        };
        number.push(n);
    }

    if number.len() < 2 {
        return false;
    }
    
    let sum = number.iter().rev().enumerate().map(|(i, n)| { 
        if i % 2 == 1 {
            let m = n * 2;
            if m > 9 {
                m - 9
            } else {
                m
            }
        } else {
            *n
        }
    }).sum::<i64>();
    sum % 10 == 0
}
