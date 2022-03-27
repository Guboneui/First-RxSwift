//
//  RxCocoaTestViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/25.
//

import UIKit
import RxSwift
import RxCocoa

class RxCocoaTestViewController: UIViewController {

    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var idValidView: UIView!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var pwValidView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    let idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let idValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()
    }
    
    
    private func bindUI() {
        
        // input: 아이디 입력, 비번 입력
        
        //let idInputObservable: Observable<String> = idField.rx.text.orEmpty.asObservable()
        
        idField.rx.text.orEmpty
            .bind(to: self.idInputText)
            .disposed(by: disposeBag)
        
        
        
//        let idValidOvservable = idInputObservable.map(checkEmailValid)
//        idValidOvservable.bind(to: idValid)
        self.idInputText.map(checkEmailValid(_:))
            .bind(to: self.idValid)
            .disposed(by: disposeBag)
        
        //let pwInputObservable: Observable<String> = pwField.rx.text.orEmpty.asObservable()
        
        pwField.rx.text.orEmpty
            .bind(to: self.pwInputText)
            .disposed(by: disposeBag)
        
        
        //let pwValidObservable = pwInputObservable.map(checkPasswordValid)
        
        self.pwInputText.map(checkPasswordValid(_:))
            .bind(to: self.pwValid)
            .disposed(by: disposeBag)
    
        
        // output: 불릿, 로그인 버튼 enable,
        
        idValid.subscribe(onNext: { check in
            self.idValidView.isHidden = check
        }).disposed(by: disposeBag)
        
        pwValid.subscribe(onNext: { check in
            self.pwValidView.isHidden = check
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(self.idValid, self.pwValid, resultSelector: {$0 && $1 })
            .subscribe(onNext: { check in
                self.loginButton.isEnabled = check
            }).disposed(by: disposeBag)
        
        
    
//        idValidOvservable.subscribe(onNext: { check in self.idValidView.isHidden = check }).disposed(by: disposeBag)
//        pwValidObservable.subscribe(onNext: { check in self.pwValidView.isHidden = check }).disposed(by: disposeBag)
//
//
//        Observable.combineLatest(idValidOvservable, pwValidObservable, resultSelector: {$0 && $1})
//            .subscribe(onNext: { check in self.loginButton.isEnabled = check }).disposed(by: disposeBag)
        
        
        
//        idField.rx.text.orEmpty
//            .map(checkEmailValid)
//            .subscribe(onNext: { check in
//                self.idValidView.isHidden = check
//            }).disposed(by: disposeBag)
//
//        pwField.rx.text.orEmpty
//            .map(checkPasswordValid)
//            .subscribe(onNext: { check in
//                self.pwValidView.isHidden = check
//            }).disposed(by: disposeBag)
//
//        Observable.combineLatest(
//            idField.rx.text.orEmpty.map(checkEmailValid),
//            pwField.rx.text.orEmpty.map(checkPasswordValid),
//            resultSelector: {s1, s2 in s1 && s2 }
//        ).subscribe(onNext: { check in
//            self.loginButton.isEnabled = check
//        }).disposed(by: disposeBag)
//
//
        
        
    }
    
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
    
}
