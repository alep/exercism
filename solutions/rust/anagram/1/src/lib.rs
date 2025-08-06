use std::collections::HashSet;

pub fn anagrams_for<'a>(word: &'a str, possible_anagrams: &'a [&'a str]) -> HashSet<&'a str> {
    let mut p: Vec<String> = vec![];
    let mut chars = word.to_lowercase().chars().collect::<Vec<char>>();
    // generate all permutations
    generate_for(chars.len(), &mut chars, &mut p);

    // create hashset for easy checking
    let mut h: HashSet<String> = HashSet::from_iter(p);

    // delete orginal word
    h.remove(&word.to_string());
    
    let mut h2 = HashSet::default();
    for anagram in possible_anagrams.iter() {
        if h.contains(&anagram.to_lowercase()) && anagram.to_lowercase() != word.to_lowercase() {
            h2.insert(*anagram);
        }
    }
    h2
}


pub fn generate_for<'a>(k: usize, word: &'a mut Vec<char>, permutations: &'a mut Vec<String>) -> &'a Vec<String>{
    if k == 1 {
        let s = word.iter().collect::<String>();
        permutations.push(s);
        return permutations
    }

    generate_for(k - 1, word, permutations);
    for i in 0..k-1 {
        if k % 2 == 0 {
            word.swap(i, k-1);
        } else {
            word.swap(0, k-1);
        }
        generate_for(k - 1, word, permutations);
    }
    permutations
}