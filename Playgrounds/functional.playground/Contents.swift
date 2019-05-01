import Foundation
precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

precedencegroup BackwardApplication {
    associativity: right
    higherThan: AssignmentPrecedence
}

infix operator |> : ForwardApplication
infix operator ?|> : ForwardApplication
infix operator <*> : ForwardApplication

infix operator <| : BackwardApplication
infix operator <|? : BackwardApplication

public func |> <T, U>(x: T, f: (T) -> U) -> U {
    return f(x)
}

public func ?|> <T, U>(x: T?, f: (T) -> U) -> U? {
    return x.map(f)
}

public func ?|> <T, U>(x: T?, f: (T) -> U?) -> U? {
    return x.flatMap(f)
}

//public func <*> <T, U>(f: ((T) -> U)?, a: T?) -> U? {
//    return a.apply(f)
//}

public func <| <T, U>(f: (T) -> U, x: T) -> U {
    return f(x)
}

public func <|? <T, U>(f: (T) -> U, x: T?) -> U? {
    return x.map(f)
}

public func <|? <T, U>(f: (T) -> U?, x: T?) -> U? {
    return x.flatMap(f)
}

//public func <*> <T, U>(a: T?, f: ((T) -> U)?) -> U? {
//    return a.apply(f)
//}

precedencegroup KleisliComposition {
    associativity: right
    higherThan: ForwardApplication
}

infix operator >=>: KleisliComposition

public func >=> <A, B, C>(f: @escaping (A) -> B?, g: @escaping (B) -> C?) -> (A) -> C? {
    return f >>> { $0.flatMap(g) }
}

public func >=> <B, C>(f: @escaping () -> B?, g: @escaping (B) -> C?) -> () -> C? {
    return f >>> { $0.flatMap(g) }
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: KleisliComposition
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

public func >>> <A, B, C>(f: @escaping (A, A) -> (B, B), g: @escaping (B, B) -> C) -> (A, A) -> C {
    return {
        let (lhs, rhs) = f($0, $1)
        return g(lhs, rhs)
    }
}

public func >>> <B, C>(f: @escaping () -> B, g: @escaping (B) -> C) -> () -> C {
    return { g(f()) }
}

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

public func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
    return f >>> g
}

precedencegroup BackwardsComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator <<<: BackwardsComposition

public func <<< <A, B, C>(_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
    return { f(g($0)) }
}

@inline(__always) public func id<T>(_ value: T) -> T {
    return value
}

public func const<A, B>(_ a: A) -> (B) -> A {
    return { _ in a }
}

public func zip<A, B>(_ b: B) -> (A) -> (A, B) {
    return { a in (a, b) }
}

// MARK: KeyPaths

public func get<Root, Value>(_ keyPath: KeyPath<Root, Value>) -> (Root) -> Value {
    return { a in
        a[keyPath: keyPath]
    }
}

public func get<Root, Value>(_ keyPath: KeyPath<Root, Value>) -> (Root, Root) -> (Value, Value) {
    return { a, b in
        (a[keyPath: keyPath], b[keyPath: keyPath])
    }
}

public func set<Root, Value>(_ keyPath: WritableKeyPath<Root, Value>, _ value: Value) -> (inout Root) -> Void {
    return { root in
        root[keyPath: keyPath] = value
    }
}

public func set<Root, Value>(_ keyPath: WritableKeyPath<Root, Value?>, _ value: Value?) -> (inout Root) -> Void {
    return { root in
        root[keyPath: keyPath] = value
    }
}

public func set<Root, Value>(_ keyPath: ReferenceWritableKeyPath<Root, Value>, _ value: Value) -> (Root) -> Void {
    return { root in
        root[keyPath: keyPath] = value
    }
}

public func set<Root, Value>(_ keyPath: ReferenceWritableKeyPath<Root, Value?>, _ value: Value?) -> (Root) -> Void {
    return { root in
        root[keyPath: keyPath] = value
    }
}

prefix operator ^

public prefix func ^ <Value>(_ value: Value) -> () -> Value {
    return { value }
}

// NOTE: Using `@available(*, unavailable)` will be totally ignored from compiler.
@available(*, deprecated, message: "`^sender(value)` is wrong. Consider replacing with `^value >>> sender`.")
public prefix func ^ <Value>(_ value: Value) -> () -> Void {
    return {}
}

extension KeyPath {
    @inline(__always)
    public static prefix func ^ (keyPath: KeyPath) -> (Root) -> Value {
        return get(keyPath)
    }

    @inline(__always)
    public static prefix func ^ (keyPath: KeyPath) -> (Root, Root) -> (Value, Value) {
        return get(keyPath)
    }
}

// MARK: Casting

public func cast<Source, Destination>(to type: Destination.Type = Destination.self) -> (Source) -> Destination? {
    return { $0 as? Destination }
}

// MARK: Tuples

public func first<T, U>(_ a: (T, U)) -> T {
    return a.0
}

public func mapFirst<A, B, C>(_ a2b: @escaping (A) -> B) -> ((A, C)) -> (B, C) {
    return { ac in (a2b(ac.0), ac.1) }
}

public func second<T, U>(_ a: (T, U)) -> U {
    return a.1
}

public func mapSecond<A, B, C>(_ b2c: @escaping (B) -> C) -> ((A, B)) -> (A, C) {
    return { ab in (ab.0, b2c(ab.1)) }
}

// MARK: Optionals

public func optionalize<A, B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
    return { a in a ?|> f }
}

public func unwrapOtherwise<T>(_ default: T) -> (T?) -> T {
    return { $0 ?? `default` }
}

// MARK: - Zip

public func zip<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
    guard let a = a, let b = b else { return nil }
    return (a, b)
}

public func equals<T>(_ lhs: T, _ rhs: T) -> Bool where T: Equatable {
    return lhs == rhs
}

public func equals<T>(_ lhs: T?, _ rhs: T?) -> Bool where T: Equatable {
    return lhs == rhs
}

//public func equals<T>(_ value: T) -> (T) -> Bool where T: Equatable {
//    return value |> curry(equals)
//}
//
//public func equals<T>(_ value: T?) -> (T?) -> Bool where T: Equatable {
//    return value |> curry(equals)
//}
//
//public func notEquals<T>(_ lhs: T, _ rhs: T) -> Bool where T: Equatable {
//    return lhs != rhs
//}
//
//public func notEquals<T>(_ value: T) -> (T) -> Bool where T: Equatable {
//    return value |> curry(notEquals)
//}

// MARK: - Map

public func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
    return { $0.map(f) }
}

// MARK: - Filter

public func filter<A>(_ f: @escaping (A) -> Bool) -> ([A]) -> [A] {
    return { $0.filter(f) }
}






///////////
///////////
///////////




let a = 20
func x(a: Int) -> String {
    return "\(a)"
}

func y(a: String) -> String {
    return "\(a)--\(a)"
}

//print(x(a: a))
print(a |> x |> y)


func f(float: Float) -> Int {
    return Int.random(in: 0..<Int(float))
}

func g(a: Int) -> String {
    return "\(a)"
}


let n = f >>> g

//print("\(n(100))")
//print("\(g(a: f(float: 100)))")





















