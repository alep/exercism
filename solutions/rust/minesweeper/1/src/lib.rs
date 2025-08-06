  

pub fn annotate(minefield: &[&str]) -> Vec<String> {
    let mut field : Vec<String> = vec![];
    for (i, row) in minefield.into_iter().enumerate() {
        let mut new_row = "".to_string();
        for (j, val) in row.chars().enumerate() {
            let mut cur = 0;
            if val == ' ' { 
                let indices : Vec<i8> = vec![-1, 0, 1];
                for a in indices.iter() {
                    for b in indices.iter() {
                        let i_i8 = i as i8;
                        let j_i8 = j as i8;
                        if i_i8 + a < 0 ||
                            i_i8 + a >= minefield.len() as i8 ||
                            j_i8 + b < 0 ||
                            j_i8 + b >= row.len() as i8 ||
                            (*a == 0 && *b == 0) {
                                continue;
                        } else {
                            let s_idx = usize::try_from(i_i8 + a).unwrap();
                            let s_jdx = usize::try_from(j_i8 + b).unwrap();
                            if &minefield[s_idx][s_jdx..s_jdx+1] == "*" {
                                cur += 1;
                            }
                        } 
                    }
                }
                if cur != 0 {
                    new_row.push_str(&format!("{:}",cur));
                } else {
                    new_row.push(' ');
                }
            } else if val == '*' {
                new_row.push('*');
            }
            
        }
        field.push(new_row);
    }
    field
}
