import gleam/list

import gleam/order.{type Order}
import gleam/float.{compare}

pub type City {
  City(name: String, temperature: Temperature)
}

pub type Temperature {
  Celsius(Float)
  Fahrenheit(Float)
}

pub fn fahrenheit_to_celsius(f: Float) -> Float {
	{ f -. 32. } /.  1.8 
}

fn normalize_temp(temp: Temperature) -> Temperature {
	case temp {
		Fahrenheit(t0) -> Celsius(fahrenheit_to_celsius(t0))
		Celsius(_) -> temp
	}
}

pub fn compare_temperature(left: Temperature, right: Temperature) -> Order {
	
	let assert Celsius(t0) = normalize_temp(left)
	let assert Celsius(t1) = normalize_temp(right)
	compare(t0, t1)
}

pub fn sort_cities_by_temperature(cities: List(City)) -> List(City) {
	list.sort(cities, by: fn(city, other_city) { compare_temperature(city.temperature, other_city.temperature)})	
}
