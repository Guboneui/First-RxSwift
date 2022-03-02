//
//  NumbersViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/03.
//

import UIKit
import RxCocoa
import RxSwift

class NumbersViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Numbers"
        
        Observable.combineLatest(firstTextField.rx.text.orEmpty, secondTextField.rx.text.orEmpty, thirdTextField.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            
        }.map {$0.description}
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag)
    }
}




