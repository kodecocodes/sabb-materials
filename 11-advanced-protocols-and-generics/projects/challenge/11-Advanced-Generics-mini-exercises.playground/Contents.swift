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

protocol Product {
  init()
}

protocol ProductionLine {
  associatedtype ProductType
  init()
  func produce() -> ProductType
}

protocol Factory {
  associatedtype ProductType: Product
  associatedtype LineType: ProductionLine
  var warehouse: [ProductType] { get set }
  var productionLines: [LineType] { get set }
  mutating func produce()
  mutating func addProductionLine()
}

extension Factory where ProductType == LineType.ProductType {
  mutating func produce() {
    var newItems: [ProductType] = []
    productionLines.forEach { newItems.append($0.produce()) }
    print("Finished Production")
    print("-------------------")
    warehouse.append(contentsOf: newItems)
  }

  mutating func addProductionLine() {
    let newProductionLine = LineType()
    productionLines.append(newProductionLine)
  }
}

struct Car: Product {
  init() {
    print("Car 🚘")
  }
}

struct Chocolate: Product{
  init() {
    print("Chocolate bar 🍫")
  }
}

struct GenericProductionLine<P: Product>: ProductionLine {
  func produce() -> P {
    P()
  }
}

struct GenericFactory<P: Product>: Factory {
  var warehouse: [P] = []
  var productionLines: [GenericProductionLine<P>] = []
}

var chocolateFactory = GenericFactory<Chocolate>()
chocolateFactory.addProductionLine()
chocolateFactory.produce()
chocolateFactory.warehouse.count
chocolateFactory.addProductionLine()
chocolateFactory.produce()
chocolateFactory.warehouse.count
