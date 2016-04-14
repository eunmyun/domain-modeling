//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

public class TestMe {
  public func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(to: String) -> Money {
    let rates = [
        "USD": 1,
        "GBP": 0.5,
        "EUR": 1.5,
        "CAN": 1.25,
    ]
    let rate = rates[to]! / rates[currency]!
    let _amount = Int(Double(amount) * rate)
    let _currency = to
    return Money(amount:_amount, currency:_currency)
  }
  
  public func add(to: Money) -> Money {
    var _amount : Int = amount
    if (currency != to.currency) {
        let converted: Money = convert(to.currency)
        _amount = converted.amount
    }
    _amount += to.amount
    return Money(amount: Int(_amount), currency: to.currency)
  }
    
  public func subtract(from: Money) -> Money {
    var _amount : Int = amount
    if (currency != from.currency) {
        let converted: Money = convert(from.currency)
        _amount = converted.amount
    }
    return Money(amount: Int(from.amount - _amount), currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
public class Job {
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
    
  public var title : String
  public var type : JobType
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  public func calculateIncome(hours: Int) -> Int {
    switch type {
        case .Hourly(let value):
            return Int(value * Double(hours))
        case .Salary(let value):
            return value
    }
  }
  
  public func raise(amt : Double) {
    switch type {
        case .Hourly(let value):
            type = .Hourly(Double(value + amt))
        case .Salary(let value):
            type = .Salary(value + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
public class Person {
  public var firstName : String = ""
  public var lastName : String = ""
  private var age : Int = 0

  private var _job : Job? = nil
  public var job : Job? {
    get {
        return _job
    }
    set(value) {
        if age >= 16 {
            _job = value
        }
    }
  }
  
  private var _spouse : Person? = nil
  public var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if (age >= 18) {
            _spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
    //"[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]"
  public func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
  }
}

////////////////////////////////////
// Family
//
public class Family {
  private var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members += [spouse1, spouse2]
    } else {
        //At least one of them is already married to someone
    }
  }
  
  public func haveChild(child: Person) -> Bool {
    for index in 0...members.count {
        if members[index].age > 21 {
            members.append(child)
            return true
        }
    }
    return false
    }
  
  public func householdIncome() -> Int {
    var total: Int = 0
    for person in members {
        if person.job?.type != nil {
            total += person.job!.calculateIncome(2000)
        }
    }
    return total
  }
}





