//
//  SimpleValidationViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/03.
//

import UIKit
import RxSwift
import RxCocoa

private let minimalUserNameLength: Int = 5
private let minimalUserPasswordLength: Int = 5

class SimpleValidationViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var idWarning: UILabel!
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwWarningLabel: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Simple Validation"
        self.idWarning.text = "Username has to be at least \(minimalUserNameLength) characters"
        self.pwWarningLabel.text = "UserPW has to be at least \(minimalUserPasswordLength) characters"
        
        let usernameValid = idTextField.rx.text.orEmpty
            .map{$0.count >= minimalUserNameLength}
            .share(replay: 1)
        
        let passwordValid = pwTextField.rx.text.orEmpty
            .map {$0.count >= minimalUserPasswordLength}
            .share(replay: 1)
        
        let everyThingValid = Observable.combineLatest(usernameValid, passwordValid) {$0 && $1}
            .share(replay: 1)
        
        usernameValid
            .bind(to: pwTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: idWarning.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: pwWarningLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        everyThingValid
            .bind(to: checkButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        checkButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else {return}
                self.showAlert()
            })
            .disposed(by: disposeBag)
        
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    

}
