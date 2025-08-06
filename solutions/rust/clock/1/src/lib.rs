use std::fmt;
use std::cmp;

#[derive(Debug)]
pub struct Clock {
    hours: i32,
    minutes: i32
}

// This is a minutes clock, think like if it was a round clock of 1440 minutes how should it warp aroud?
fn warp(minutes: i32) -> i32 {
    let mut offset: i32 = 0;
    const n: i32 = 1440;
    if minutes < 0 {
        offset = (-minutes / n) + 1;
    }    
    return (minutes + (n * offset)) % n;
}
    
impl Clock {
    pub fn new(hours: i32, minutes: i32) -> Self {
        let m = warp(hours * 60) + warp(minutes);
        Self { hours: (m / 60) % 24, minutes: m % 60 }
    }
    
    pub fn add_minutes(&mut self, minutes: i32) -> Self {
        let m = warp(minutes);
        let current_clock = self.hours * 60 + self.minutes;
        let new_clock = current_clock + m;
        Self { hours: (new_clock / 60) % 24, minutes: new_clock % 60 }
    }
}

impl cmp::PartialEq for Clock {
    fn eq(&self, other: &Self) -> bool {
        self.hours == other.hours && self.minutes == other.minutes
    }
}

impl fmt::Display for Clock {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:0>2}:{:0>2}", self.hours, self.minutes)
    }
}