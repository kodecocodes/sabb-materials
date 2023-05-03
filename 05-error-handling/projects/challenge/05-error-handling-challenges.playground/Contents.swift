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
 ## Error Handling
 ### Challenge 1: Even strings
 Write a function that converts a `String` to an even number, rounding down if necessary. It should throw if the `String` is not a valid number.
 */
enum NumberError: Error {
  case notANumber
}

func toEvenNumber(_ string: String) throws -> Int {
  guard let number = Int(string) else {
    throw NumberError.notANumber
  }
  return number - number % 2
}

do {
  try toEvenNumber("10")
} catch {
  print("You can't convert the string to a number!")
}

do {
  try toEvenNumber("1")
} catch {
  print("You can't convert the string to a number!")
}

do {
  try toEvenNumber("abc")
} catch {
  print("You can't convert the string to a number!")
}

/*:
 ### Challenge 2: Safe division
 Write a function that divides two `Int`s. It should throw if the divisor is zero.
 */
enum DivisionError: Error {
  case divisionByZero
}

func divide(_ x: Int, _ y: Int) throws -> Int {
  guard y != 0 else {
    throw DivisionError.divisionByZero
  }
  return x/y
}

do {
  try divide(10, 2)
} catch {
  print("You can't divide by zero!")
}

do {
  try divide(10, 0)
} catch {
  print("You can't divide by zero!")
}

/*:
 ### Challenge 3: Account login
 Given the following code:
 ```
 class Account {
   let token: String
 }

 enum LoginError: Error {
   case invalidUser
   case invalidPassword
 }

 func onlyAliceLogin(username: String, password: String) throws -> String {
   guard username == "alice" else {
     throw LoginError.invalidUser
   }
   guard password == "hunter2" else {
     throw LoginError.invalidPassword
   }
   return "AUTH_TOKEN"
 }
 ```

 Write an initializer for `Account` that takes a username, password, and a `loginMethod` closure. The `loginMethod` closure should itself take two `String` parameters and return a `String`. The `loginMethod` should be called and the result set to the `Account`'s `token` variable. The `loginMethod` closure should be able to throw.

 This initializer should work when used with the following examples:
 ```
 let account1 = try? Account(username: "alice", password: "hunter2", loginMethod: onlyAliceLogin)

 let account2 = Account(username: "alice", password: "hunter2") { _, _ in
   return "AUTH_TOKEN"
 }
 ```
 */

class Account {
  let token: String

  init(username: String, password: String, loginMethod: (String, String) throws -> String) rethrows {
    self.token = try loginMethod(username, password)
  }
}

enum LoginError: Error {
  case invalidUser
  case invalidPassword
}

func onlyAliceLogin(username: String, password: String) throws -> String {
  guard username == "alice" else {
    throw LoginError.invalidUser
  }
  guard password == "hunter2" else {
    throw LoginError.invalidPassword
  }
  return "AUTH_TOKEN"
}

let account1 = try? Account(username: "alice", password: "hunter2", loginMethod: onlyAliceLogin)

let account2 = Account(username: "alice", password: "hunter2") { _, _ in
  return "AUTH_TOKEN"
}
