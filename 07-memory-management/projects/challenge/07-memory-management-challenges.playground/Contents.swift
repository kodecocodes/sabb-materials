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

/*:
 ## Memory Management
 ### Challenge 1: Break the cycle
 
 Break the strong reference cycle in the following code:
 
 ```
 class Person {
   let name: String
   let email: String
   var car: Car?
   init(name: String, email: String) {
     self.name = name
     self.email = email
   }
   deinit {
     print("Goodbye \(name)!")
   }
 }
 
 class Car {
   let id: Int
   let type: String
   var owner: Person?
   init(id: Int, type: String) {
     self.id = id
     self.type = type
   }
   deinit {
     print("Goodbye \(type)!")
   }
 }
 var owner: Person? = Person(name: "Alice", email: "alice@wonderland.magical")
 var car: Car? = Car(id: 10, type: "BMW")
 owner?.car = car
 car?.owner = owner
 owner = nil
 car = nil
 ```
 */
class Person {
  let name: String
  let email: String
  weak var car: Car?
  init(name: String, email: String) {
    self.name = name
    self.email = email
  }
  
  deinit {
    print("Goodbye \(name)!")
  }
}

class Car {
  let id: Int
  let type: String
  var owner: Person?
  
  init(id: Int, type: String) {
    self.id = id
    self.type = type
  }
  
  deinit {
    print("Goodbye \(type)!")
  }
}

var owner: Person? = Person(name: "Alice", email: "alice@wonderland.magical")
var car: Car? = Car(id: 10, type: "BMW")

owner?.car = car
car?.owner = owner

owner = nil
car = nil

/*:
 ### Challenge 2: Break another cycle
 
 Break the strong reference cycle in the following code:
 
 ```
 class Customer {
   let name: String
   let email: String
   var account: Account?
 
   init(name: String, email: String) {
     self.name = name
     self.email = email
   }
 
   deinit {
     print("Goodbye \(name)!")
   }
 }
 
 class Account {
   let number: Int
   let type: String
   let customer: Customer
 
   init(number: Int, type: String, customer: Customer) {
     self.number = number
     self.type = type
     self.customer = customer
   }
 
   deinit {
     print("Goodbye \(type) account number \(number)!")
   }
 }
 
 var customer: Customer? = Customer(name: "George", email: "george@whatever.com")
 var account: Account? = Account(number: 10, type: "PayPal", customer: customer!)
 
 customer?.account = account
 
 account = nil
 customer = nil
 ```
 */
class Customer {
  let name: String
  let email: String
  var account: Account?
  
  init(name: String, email: String) {
    self.name = name
    self.email = email
  }
  
  deinit {
    print("Goodbye \(name)!")
  }
}

class Account {
  let number: Int
  let type: String
  unowned let customer: Customer // An account should always be assigned to a customer, so use unowned instead of weak
  
  init(number: Int, type: String, customer: Customer) {
    self.number = number
    self.type = type
    self.customer = customer
  }
  
  deinit {
    print("Goodbye \(type) account number \(number)!")
  }
}

var customer: Customer? = Customer(name: "George", email: "george@whatever.com")
var account: Account? = Account(number: 10, type: "PayPal", customer: customer!)

customer?.account = account

account = nil
customer = nil


/*:
 ### Challenge 3: Break this retain cycle involving closures

 Break the strong reference cycle in the following code:

 ```
 class Calculator {
   var result: Int = 0
   var command: ((Int) -> Int)? = nil

   func execute(value: Int) {
     guard let command = command else { return }
     result = command(value)
   }

   deinit {
     print("Goodbye MathCommand! Result was \(result).")
   }
 }

 do {
   var calculator = Calculator()
   calculator.command = { (value: Int) in
     return calculator.result + value
   }

   calculator.execute(value: 1)
   calculator.execute(value: 2)
 }
 ```
 */

class Calculator {
  var result: Int = 0
  var command: ((Int) -> Int)? = nil

  func execute(value: Int) {
    guard let command = command else { return }
    result = command(value)
  }

  deinit {
    print("Goodbye MathCommand! Result was \(result).")
  }
}

do {
  var calculator = Calculator()
  calculator.command = { [weak calculator] (value: Int) in
    guard let calculator = calculator else { return 0 }
    return calculator.result + value
  }

  calculator.execute(value: 1)
  calculator.execute(value: 2)
}
