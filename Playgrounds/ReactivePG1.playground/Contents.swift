import UIKit
import ReactiveSwift
import Result

var str = "Hello, playground"
print(str)

class Point {
    var x: Int = 0
    var y: Int = 0
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    let (requestSignal, requestObserver) = Signal<String, NoError>.pipe()
    
    func isValidPoint() -> SignalProducer<Bool, NoError> {
        return SignalProducer { observer, disposable in
            self.requestObserver.send(value: "\(self.x)")
            observer.send(value: true)
            observer.sendCompleted()
        }
    }
}

var p = Point(x: 10, y: 20)

p.requestSignal.observeValues { (value) in
    print("\(value)")
}
//
//let err = p.isValidPoint().promoteError(NoError.self)
//    .attemptMap {_ in
//        return Result<(),NoError>((),failWith: .userNameUnavailable)
//    }


struct A {
    var b: Int = 0
}
var a = [A(), A(), A()]
var c = [1, 2, 3]

if a.count == c.count {
    (0..<a.count).forEach {
        a[$0].b = c[$0]
    }
}
