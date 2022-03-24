//
//  RxSwift4HourViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/15.
//

import UIKit
import RxSwift

// RxSwift 공식 홈페이지의 Docs를 보면 5가지가 나오게 된다.
// 5가지는 Observable, Operators, Single, Subject, Scheduler 로 구성되어 있으며
// 사실상 가장 중요한 부분은 Observable, Operators, Scheduler 순으로 생각할 수 있다.
// 각각의 역할들은 다시 정리할 예정이며,
// 자세한 내용은 해당 링크에서 확인할 수 있다. -> https://reactivex.io/documentation/ko/observable.html


// 일반적인 로직에서 비동기 처리를 하기 위해서는 DispatchQueue.global().async 를 통해서 비동기 처리로 진행을 해준다.
// 단, UI를 처리하는 로직은 main에서 처리해 준다


class RxSwift4HourViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    var counter: Int = 0
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLabel.text = "\(self.counter)"
        }
    }
    
    @IBAction func onLoadImage(_ sender: Any) {
        self.imageView.image = nil
        
        rxswiftLoadImage(from: LARGE_IMAGE_URL)
            .observe(on: MainScheduler.instance)
            .subscribe({ result in
                // subscribe 된 것을 변수를 통해서 받는다
                // subscribe를 할 경우 disposable이 리턴됨
                switch result {
                case let .next(image):
                    self.imageView.image = image
                case let .error(error):
                    print(error.localizedDescription)
                
                case .completed:
                    break
                }
                
            })
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        disposeBag = DisposeBag()
        // disposeBag은 Dispose 메소드를 제공하지 않는다.
        // 따라서 새로 만들어서 기존의 내용을 삭제 해준다.
    }
    
    func rxswiftLoadImage(from imageUrl: String) -> Observable<UIImage?> {
        return Observable.create { seal in
            asyncLoadImage(from: imageUrl) { image in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    // 옵저버블을 리턴하기 위해서 기존에는
    // onCreate -> onNext를 통해서 인자를 전달
    // 하지만 해당 과정의 귀찮아서
    // 오퍼레이터를 통해서 데이터를 직접 받을 수 있도록 create 해준다.
    
    // RxSwift의 기본 작동 방식
    // 옵저버블을 만들고(ex. create, 오퍼레이터(just...)
    // 이것을 구독 (subscribe)
    // 구독을 하게 되면 옵저버블에서 만들어진 데이터가 클로저의 인자로 넘어오게 됨.
    
    
    @IBAction func firstJustClicked(_ sender: Any) {
//        Observable.just("Hello, This is First just button")
//            .subscribe(onNext: { str in
//                print(str)
//            }).disposed(by: disposeBag)
        
        Observable.just("test String")
             
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    
    
    @IBAction func secondJustClicked(_ sender: Any) {
        // just를 통해 문자열을 전달할 수도 있지만, 배열(컬렉션) 또한 전달할 수 있다.
        Observable.just(["this", "is", "first", "just", "button"])
            .subscribe(onNext: { arr in
                print(arr)
            }).disposed(by: disposeBag)
        
    }
    
    
    @IBAction func firstFromClicked(_ sender: Any) {
        // from은 배열의 요소들을 하나씩 보내줌
//        Observable.from(["This", "is", "From", "오퍼레이터"])
//            .subscribe(onNext: {
//                print($0)
//            }).disposed(by: disposeBag)
        
        Observable.from(["a", "b", "c", "d"])
            .subscribe({ event in
                
                switch event {
                case .next(let str):
                    print("next: \(str)")
                    break
                
                case .error(let error):
                    print("error: \(error.localizedDescription)")
                    break
                    
                case .completed:
                    print("completed")
                    break
                }
                
            }).disposed(by: disposeBag)
        
        
        
    }
    
    
    @IBAction func firstMapClicked(_ sender: Any) {
        // map은 단독 사용은 안되며, just 또는 from으로 부터 내려온 값을 변형 또는 합쳐주는 역할을 함.
        Observable.just("Hello")
            .map{ str in "\(str) RxSwift"}
            .subscribe(onNext: { str in
                print(str)
                
            }).disposed(by: disposeBag)
    }
    
    
    @IBAction func secondMapClicked(_ sender: Any) {
//        Observable.from(["a", "b", "c"])
//            .map{"\($0) + This is Arr"}
//            .subscribe(onNext: { str in
//                print(str)
//                print(type(of: str))
//
//            }).disposed(by: disposeBag)
        
//        Observable.from(["a", "b", "c"])
//            .map{ $0.count }
//            .subscribe(onNext: {
//                print("\($0), \(type(of: $0))")
//            }).disposed(by: disposeBag)
        
        
    }
    
    @IBAction func firstFilterClicked(_ sender: Any) {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
            .filter{ $0 % 2 == 0 }
            .subscribe(onNext: { number in
                print(number)
            }).disposed(by: disposeBag)
    }
    
    
    @IBAction func thirdMapClicked(_ sender: Any) {
        Observable.just("800x600")
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .map { $0.replacingOccurrences(of: "x", with: "/") }
            .map { "https://picsum.photos/\($0)/?random" }
            .map { URL(string: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .map { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { image in
                self.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
    
}
