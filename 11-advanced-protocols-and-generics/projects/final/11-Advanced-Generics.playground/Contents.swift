/// Copyright (c) 2023 Kodeco LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

//protocol Pet {
//  var name: String { get }
//}
//struct Cat: Pet {
//  var name: String
//}

//var pet: any Pet = Cat(name: "Whiskers")

protocol Pet {
  associatedtype Food
  var name: String { get }
}

struct DogFood { }

struct Dog: Pet {
    typealias Food = DogFood
    var name: String
}

var pet: any Pet = Dog(name: "Mattie")

//protocol WeightCalculatable {
//  associatedtype WeightType
//  var weight: WeightType { get }
//}

class Truck: WeightCalculatable {
  // This heavy thing only needs integer accuracy

  var weight: Int {
    100
  }
}

class Flower: WeightCalculatable {
  // This light thing needs decimal places

  var weight: Double {
    0.0025
  }
}

//class StringWeightThing: WeightCalculatable {
//  typealias WeightType = String
//
//  var weight: String {
//    "That doesn't make sense"
//  }
//}

//class DogWeightThing: WeightCalculatable {
//  typealias WeightType = Dog
//
//  var weight: Dog {
//    Dog(name: "Rufus") // What is a dog doing here?
//  }
//}

protocol WeightCalculatable {
  associatedtype WeightType: Numeric
  var weight: WeightType { get }
}

extension WeightCalculatable {
  static func + (left: Self, right: Self) -> WeightType {
    left.weight + right.weight
  }
}

var heavyTruck1 = Truck()
var heavyTruck2 = Truck()
heavyTruck1 + heavyTruck2 // 200

var lightFlower1 = Flower()
//heavyTruck1 + lightFlower1 // the compiler detects your coding error

//protocol Product {}
//
//protocol ProductionLine  {
//  func produce() -> any Product
//}
//
//protocol Factory {
//  var productionLines: [any ProductionLine] {get}
//}
//
//extension Factory {
//  func produce() -> [any Product] {
//    var items: [any Product] = []
//    productionLines.forEach { items.append($0.produce()) }
//    print("Finished Production")
//    print("-------------------")
//    return items
//  }
//}
//

struct Car: Product {
  init() {
    print("Car 🚘")
  }
}
//
//struct CarProductionLine: ProductionLine {
//  func produce() -> any Product {
//    Car()
//  }
//}
//
//struct CarFactory: Factory {
//  var productionLines: [any ProductionLine] = []
//}
//
//var carFactory = CarFactory()
//carFactory.productionLines = [CarProductionLine(), CarProductionLine()]
//carFactory.produce()
//
//struct Chocolate: Product {
//  init() {
//    print("Chocolate bar 🍫")
//  }
//}
//
//struct ChocolateProductionLine: ProductionLine {
//  func produce() -> Product {
//    Chocolate()
//  }
//}

//var oddCarFactory = CarFactory()
//oddCarFactory.productionLines = [CarProductionLine(), ChocolateProductionLine()]
//oddCarFactory.produce()

protocol Product {
  init()
}

protocol ProductionLine<ProductType> {
  associatedtype ProductType: Product
  func produce() -> ProductType
}

protocol Factory {
  associatedtype ProductType: Product
  associatedtype LineType: ProductionLine
  var productionLines: [LineType] { get }
  func produce() -> [ProductType]
}

extension Factory where ProductType == LineType.ProductType {
  func produce() -> [ProductType] {
    var newItems: [ProductType] = []
    productionLines.forEach { newItems.append($0.produce()) }
    print("Finished Production")
    print("-------------------")
    return newItems
  }
}

struct GenericProductionLine<P: Product>: ProductionLine {
  func produce() -> P {
    P()
  }
}

struct GenericFactory<P: Product>: Factory {
  var productionLines: [GenericProductionLine<P>] = []
  typealias ProductType = P
}

var carFactory = GenericFactory<Car>()
carFactory.productionLines = [GenericProductionLine<Car>(), GenericProductionLine<Car>()]
carFactory.produce()

// MARK: -

func sum<C: Collection>(_ input: C) -> C.Element where C.Element: Numeric {
  input.reduce(0, +)
}

sum([1, 2, 3]) // Returns Int: 6
sum([1.25, 2.25, 3.25]) // Returns Double: 6.75


// MARK: -


func produceCars(line: any ProductionLine<Car>, count: Int) -> [Car] {
  (1...count).map { _ in line.produce() }
}

produceCars(line: GenericProductionLine<Car>(), count: 5)

// MARK: -

let array = Array(1...10)
let set = Set(1...10)
let reversedArray = array.reversed()

for e in reversedArray {
 print(e)
}

let arrayCollections = [array, Array(set), Array(reversedArray)]

do {
  let collections = [AnyCollection(array),
                     AnyCollection(set),
                     AnyCollection(array.reversed())]
  let total = collections.reduce(0) { $0 + $1.reduce(0, +) } // 165
}

do {
  let collections: [any Collection<Int>] = [array, set, reversedArray]
  let total = collections.reduce(0) { $0 + $1.reduce(0, +) } // 165
}

do {
  let collections = [AnyCollection(array),
                     AnyCollection(set),
                     AnyCollection(array.reversed())]
  let total = collections.flatMap { $0 }.reduce(0, +) // 165
}

// MARK: -

func makeValue() -> some FixedWidthInteger {
  42
}

print("Two makeVales summed", makeValue() + makeValue())

func makeValueRandomly() -> some FixedWidthInteger {
  if Bool.random() {
    return Int(42)
  }
  else {
    // return Int8(24) // Compiler error.  All paths must return same type.
    return Int(24)
  }
}

let v: any FixedWidthInteger = 42 // compiler error
//let v = makeValue() // works

func makeEquatableNumericInt() -> some Numeric & Equatable { 1 }
func makeEquatableNumericDouble() -> some Numeric & Equatable { 1.0 }

let value1 = makeEquatableNumericInt()
let value2 = makeEquatableNumericInt()

print(value1 == value2) // prints true
print(value1 + value2) // prints 2
// print(value1 > value2) // error

// Compiler error, types don't match up
// makeEquatableNumericInt() == makeEquatableNumericDouble()

var someCollection : some Collection = [1, 2, 3]
print(type(of: someCollection)) // Array<Int>

// someCollection.append(4)

var intArray = [1, 2, 3]
var intSet = Set([1, 2, 3])

//var arrayOfSome: [some Collection] = [intArray, intSet] // Compiler error
var arrayOfAny: [any Collection] = [intArray, intSet]

var someArray: some Collection<Int> = intArray
var someSet: some Collection<Int> = intSet
//someArray = someSet // Compiler error
//someSet = someArray // Compiler error

var anyElement: any Collection<Int> = intArray
anyElement = intSet
anyElement

var intArray2 = [1, 2, 3]
var someArray2: some Collection<Int> = intArray2
//someArray = someArray2 // Compiler Error


// MARK: -

do {
  func product<C: Collection>(_ input: C) -> Double where C.Element == Double {
    input.reduce(1, *)
  }
  product([1,2,3,4])
}

do {
  func product(_ input: some Collection<Double>) -> Double {
    input.reduce(1, *)
  }
  product([1,2,3,4])
}

