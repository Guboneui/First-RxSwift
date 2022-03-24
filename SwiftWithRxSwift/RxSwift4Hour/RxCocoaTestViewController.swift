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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()
    }
    
    
    private func bindUI() {
        idField.rx.text.orEmpty
            .map(checkEmailValid)
            .subscribe(onNext: { check in
                self.idValidView.isHidden = check
            }).disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .map(checkPasswordValid)
            .subscribe(onNext: { check in
                self.pwValidView.isHidden = check
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(
            idField.rx.text.orEmpty.map(checkEmailValid),
            pwField.rx.text.orEmpty.map(checkPasswordValid),
            resultSelector: {s1, s2 in s1 && s2 }
        ).subscribe(onNext: { check in
            self.loginButton.isEnabled = check
        }).disposed(by: disposeBag)
        
        
        
        
    }
    
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
    
}
