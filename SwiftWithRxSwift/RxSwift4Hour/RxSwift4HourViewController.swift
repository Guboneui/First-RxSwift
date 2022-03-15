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

}
