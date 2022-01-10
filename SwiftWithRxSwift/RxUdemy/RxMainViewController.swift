//
//  RxMainViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/11.
//

import UIKit
import RxSwift

class RxMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = Observable.from([1, 2, 3, 4, 5])
    }
    

}
