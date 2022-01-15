import UIKit
import RxSwift
import RxRelay
import PlaygroundSupport

//let observable1 = Observable.just(1)
//let observable2 = Observable.of(1, 2, 3)
//let observable3 = Observable.of([1, 2, 3])
//let observable4 = Observable.from([1, 2, 3, 4, 5])
//
//observable4.subscribe { event in
//    if let element = event.element {
//        print(element)
//    }
//}
//
//
//observable2.subscribe(onNext: { element in
//    print(element)
//})

//let disposeBag = DisposeBag()
//
//Observable.of("A", "B", "C")
//    .subscribe {
//        print($0)
//    }.disposed(by: disposeBag)
//
//
//Observable<String>.create { observer in
//    observer.onNext("A")
//    observer.onCompleted()
//    observer.onNext("?")
//    return Disposables.create()
//}.subscribe(onNext: {print($0)},
//            onError: {print($0)},
//            onCompleted: {print("Completed")},
//            onDisposed: {print("Disposed")}
//).disposed(by: disposeBag)


let disposeBag = DisposeBag()

//let subject = PublishSubject<String>()
//subject.onNext("Issue 1")
//subject.subscribe { event in
//    print(event)
//}
//
//subject.onNext("Issue 2")
//subject.onNext("Issue 3")
//
//subject.dispose()
//subject.onNext("Issue 4")

//let subject = BehaviorSubject(value: "Initial Value")
//
////subject.onNext("Issue 0")
//
//subject.subscribe { event in
//    print(event)
//}
//
//subject.onNext("Issue 1")

//let subject = ReplaySubject<String>.create(bufferSize: 2)
////subject.onNext("Issue 1")
////subject.onNext("Issue 2")
////subject.onNext("Issue 3")
//
//subject.subscribe {
//    print($0)
//}
//
//subject.onNext("Issue 1")
//subject.onNext("Issue 2")
//subject.onNext("Issue 3")
//
//subject.onNext("Issue 4")
//subject.onNext("Issue 5")
//subject.onNext("Issue 6")
//
//print("[Subscription 2]")
//subject.subscribe {
//    print($0)
//}

/// RxSwift 5.0 이상부터는 Variable이 사용되지 않음 -> 4.000 버전에서는 사용 가능
/// RxSwift 5에서는 이제 공식적으로 완전히 사용되지 않으며 이러한 종류의 동작이 필요한 경우 대신 BehaviorRelay(또는 BehaviorSubject) 을 사용하는 것이 좋습니다 .
//let variable = Variable.init("Initial Value")
//variable.value = "Hello World")
//variable.asObservable()

//let relay = BehaviorRelay(value: "Initial Value")
//
//relay.asObservable()
//    .subscribe {
//        print($0)
//    }
//
//relay.accept("Hello World")

//let relay = BehaviorRelay(value: [String]())
//
//relay.accept(["Item 1", "Item 2"])
//
//relay.asObservable()
//    .subscribe {
//        print($0)
//    }

//let relay = BehaviorRelay(value: ["Item1"])
//
////relay.accept(relay.value + ["Item 2"])
//var value = relay.value
//value.append("Item new")
//value.append("Item new3")
//
//relay.accept(value)
//
//relay.asObservable()
//    .subscribe {
//        print($0)
//    }

let strikes = PublishSubject<String>()

// MARK: - ignoreElement()
//strikes
//    .ignoreElements()
//    .subscribe {
//        print($0)
//    }.disposed(by: disposeBag)
//
//strikes.onNext("A")
//strikes.onNext("B")
//strikes.onNext("C")
//
//strikes.onCompleted()

// MARK: - element(at: Int)
//strikes.element(at: 2)
//    .subscribe(onNext: { _ in
//        print("you are out!")
//    }).disposed(by: disposeBag)
//
//strikes.onNext("x")
//strikes.onNext("x")
//strikes.onNext("x")

// MARK: - filter

//Observable.of(1, 2, 3, 4, 5, 6, 7)
//    .filter { $0 % 2 == 0 }
//    .subscribe(onNext:{
//        print($0)
//    }).disposed(by: disposeBag)

// MARK: - skip

//Observable.of("A", "B", "C", "D", "E")
//    .skip(3)
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)

// MARK: - skip(while: )

//Observable.of(1, 2, 3, 4, 5, 6, 7)
//    .skip(while: {  // 특정값에 만족하지 않는 값을 지나게 되면 이후에는 모두 출력
//        $0 % 2 == 1
//    })
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)


// MARK: - skip(until: )
//let subject = PublishSubject<String>()
//let trigger = PublishSubject<String>()
//subject.skip(until: trigger)
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//
//subject.onNext("A")
//subject.onNext("B")
//trigger.onNext("X") // 트리거가 시작되면 시작
//subject.onNext("C")

// MARK: - take

//Observable.of(1, 2, 3, 4, 5, 6)
//    .take(3)
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)

// MARK: - take(while: )

//Observable.of(1, 2, 3, 4, 5, 6, 7)
//    .take(while: {
//        $0 % 2 == 1
//    }).subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)

//let subject = PublishSubject<String>()
//let trigger = PublishSubject<String>()
//
//subject.take(until: trigger)
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//
//subject.onNext("1")
//subject.onNext("2")
//trigger.onNext("X")
//trigger.onNext("3")


// MARK: - 변환 연산자

// toArray()
//Observable.of(1, 3, 4, 5, 6)
//    .toArray()
//    .subscribe({
//        print($0)
//    }).disposed(by: disposeBag)

// map
//Observable.of(1, 2, 3, 4, 5)
//    .map {
//        return $0*2
//    }.subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)

// flatMap
struct Student {
    var score: BehaviorRelay<Int>
    
}

//let john = Student(score: BehaviorRelay(value: 90))
//let mary = Student(score: BehaviorRelay(value: 80))
//
//let student = PublishSubject<Student>()
//student.asObserver()
//    .flatMap {
//        $0.score.asObservable()}
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//
//student.onNext(john)
//john.score.accept(100)
//
//student.onNext(mary)
//mary.score.accept(10)


// flatMapLatest
//let john = Student(score: BehaviorRelay(value: 90))
//let mary = Student(score: BehaviorRelay(value: 80))
//
//let student = PublishSubject<Student>()
//student.asObserver()
//    .flatMapLatest {
//        $0.score.asObservable()}
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//
//student.onNext(john)
//john.score.accept(100)
//student.onNext(mary)
//john.score.accept(10)
//


// MARK: - combining operators
// startWith 시작 부분에 데이터 삽입
let numbers = Observable.of(2, 3, 4)
let observable = numbers.startWith(1)
observable.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)
