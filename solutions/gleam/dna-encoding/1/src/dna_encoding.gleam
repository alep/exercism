import gleam/list
import gleam/result

pub type Nucleotide {
  Adenine
  Cytosine
  Guanine
  Thymine
}

pub fn encode_nucleotide(nucleotide: Nucleotide) -> Int {
  case nucleotide {
    Adenine -> 0b00
    Cytosine -> 0b01
    Guanine -> 0b10
    Thymine -> 0b11
  }
}

pub fn decode_nucleotide(nucleotide: Int) -> Result(Nucleotide, Nil) {
  case nucleotide {
    0 -> Ok(Adenine)
    1 -> Ok(Cytosine)
    2 -> Ok(Guanine)
    3 -> Ok(Thymine)
    _ -> Error(Nil)
  }
}


pub fn encode(dna: List(Nucleotide)) -> BitArray {
  dna |> list.map(fn(value) { <<encode_nucleotide(value):size(2)>> } )
      |> list.reduce(fn(fst, snd) { <<fst:bits, snd:bits>> })
      |> result.unwrap(<<0>>)
}


fn d(dna: BitArray, acc: List(Nucleotide)) -> Result(List(Nucleotide), Nil) {
  case dna {
    <<0:2, rest:bits>> -> d(rest, [Adenine, ..acc])
    <<1:2, rest:bits>> -> d(rest, [Cytosine, ..acc])
    <<2:2, rest:bits>> -> d(rest, [Guanine, ..acc])
    <<3:2, rest:bits>> -> d(rest, [Thymine, ..acc])
    <<_value:2, _rest:bits>> -> Error(Nil)
    <<_value:1, _rest:bits>> -> Error(Nil)
    _ -> Ok(acc |> list.reverse)
  }
}

pub fn decode(dna: BitArray) -> Result(List(Nucleotide), Nil) {
     d(dna, [])
}