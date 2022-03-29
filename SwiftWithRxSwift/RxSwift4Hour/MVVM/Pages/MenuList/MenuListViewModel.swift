//
//  MenuListViewModel.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/30.
//

import Foundation
import RxSwift

class MenuListViewModel {

    lazy var menuObservable = BehaviorSubject<[Menu]>(value: [])
    
    
    //var itemsCount: Int = 5
    //var totalPrice: PublishSubject<Int> = PublishSubject()
    
    lazy var itemCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    lazy var totalPrice = menuObservable.map {
        $0.map{ $0.price * $0.count }.reduce(0, +)
    }
    
    // subject
    // 서브젝트는 옵저버블 처럼 구독해서 값을 받을수도 있지만, 외부에서 값을 통제할 수 도 있다.

    init() {
        var menus: [Menu] = [
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김2", price: 100, count: 0),
            Menu(name: "튀김3", price: 100, count: 0),
        ]
        menuObservable.onNext(menus)
    }
    
}
