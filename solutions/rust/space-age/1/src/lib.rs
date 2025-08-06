// The code below is a stub. Just enough to satisfy the compiler.
// In order to pass the tests you can add-to or change any of this code.

#[derive(Debug)]
pub struct Duration {
    seconds: u64,
    years: f64
}

impl From<u64> for Duration {
    fn from(s: u64) -> Self {
        Duration { 
            seconds: s,
            years: s as f64 / 31_557_600.0
        }
    }
}

pub trait Planet {
    fn years_during(d: &Duration) -> f64 {
        todo!("convert a duration ({d:?}) to the number of years on this planet for that duration");
    }
}

macro_rules! orbital_period {
    (Mercury) => (0.2408467 as f64);
    (Venus) =>	(0.61519726 as f64);
    (Earth)	=> (1.0 as f64);
    (Mars)	=> (1.8808158 as f64);
    (Jupiter)	=> (11.862615 as f64); 
    (Saturn)	=> (29.447498 as f64);
    (Uranus)	=> (84.016846 as f64);
    (Neptune)	=> (164.79132 as f64);    
}

macro_rules! impl_Planet {
    (for $($t:tt),+) => {
        $(impl Planet for $t {
            fn years_during(d: &Duration) -> f64 {
                d.years / orbital_period!($t)
            }
        })*
    }
}

impl_Planet!(for Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune);

pub struct Mercury;
pub struct Venus;
pub struct Earth;
pub struct Mars;
pub struct Jupiter;
pub struct Saturn;
pub struct Uranus;
pub struct Neptune;


