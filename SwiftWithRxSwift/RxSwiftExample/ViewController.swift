//
//  ViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2021/12/23.
//

import UIKit
import RxSwift
import Alamofire


struct kkk: Decodable {
    let arr: [dataModel]
}

struct dataModel: Decodable {
    var age: Int
    var avatar: String
    var id: Int
    var job: String
    var name: String
}

struct LogoutResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
}


let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"


class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var editView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var disposable = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else {return}
            self.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }
    
    
    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    // Observable의 생명주기
    // 1. create
    // 2. Subscribe
    // 3. onNext
    // 4. onCompleted || onError
    // 5. Disposed
    
    
    
    func downloadJson(_ url: String) -> Observable<String?> {

        return Observable.just("hello world")
//        return Observable.create { emmiter in
//            let url = URL(string: url)!
//            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//                guard error == nil else {
//                    emmiter.onError(error!)
//                    return
//                }
//
//                if let data = data, let json = String(data: data, encoding: .utf8) {
//                    emmiter.onNext(json)
//                }
//
//                emmiter.onCompleted()
//            }
//            task.resume()
//            return Disposables.create() {
//                task.cancel()
//            }
//        }
        
//        return Observable.create { k -> Disposable in
//            AF.request(url, method: .get, headers: nil)
//                .validate()
//                .responseDecodable(of: LogoutResponse.self) { response in
//                    switch response.result {
//                    case .success(let data):
//                        print(data)
//                        if data.isSuccess {
//                            print("로그아웃 성공")
//                            k.onNext(data)
//                            k.onCompleted()
//                        } else {
//                            print("로그아웃 실패")
//                            k.onNext(data)
//                            k.onCompleted()
//                        }
//
//                    case .failure(let error):
//                        print(error)
//                        k.onError(error)
//                    }
//
//            }
//            return Disposables.create()
//        }
        
    }
    
    
    @IBAction func onLoad(_ sender: Any) {
        editView.text = ""
        
        self.setVisibleWithAnimation(self.activityIndicator, true)
        
        downloadJson(MEMBER_LIST_URL)
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            }).disposed(by: disposable)
    
//            .subscribe { event in   //subscribe가 붙었을 때 옵저버블은 실행된다.
//                switch event {
//                case let .next(json):
////                    DispatchQueue.main.async {
////                        self.editView.text = json
////                        self.setVisibleWithAnimation(self.activityIndicator, false)
////                    }
//                    print(json)
//                case .completed:
//                    break
//                case .error:
//                    break
//                }
//            }

        
        
        
        
        
        
//        downloadJson("http://3.134.232.146:8000/auth/logout")
//            .subscribe { event in
//                // 성공시 next() 로 묶여서 나옴
//                switch event {
//                case .next(let json) :  // next로 넘어오는 데이터를 json 이라고 칭함
//                    print(json)
//                    //self.editView.text = json
//                    self.setVisibleWithAnimation(self.activityIndicator, false)
//
//                case .completed:
//                    print("completed")
//                    break
//                case .error(_):
//                    break
//                }
//
//            }
        
        
        // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
        // 2. Observable로 오는 데이터를 받아서 처리하는 방법
        
        
        
    }
}

