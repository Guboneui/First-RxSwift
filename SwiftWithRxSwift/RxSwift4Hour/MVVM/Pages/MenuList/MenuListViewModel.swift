//
//  MenuListViewModel.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/30.
//

import Foundation
import RxSwift
import RxRelay

// 모든 데이터에 대한 처리는 ViewModel에서 처리한다.

class MenuListViewModel {

    // UI와 연결된 서브젝트는 에러가 난다고 해서 스트림이 끊어지면 안됨 -> UI에서도 끊어지기 때문에
    // 따라서 Subject도 끊어지면 안됨
    // cocoa에서는 drive
    // subject 에서는 relay
    //var menuObservable = BehaviorSubject<[Menu]>(value: [])
    // subject에서는 next, error, completed 를 뱉어내지만
    // relay에서는 내보내기만 하기 때문에 onNext가 아닌 accept를 사용한다.
    
    var menuObservable = BehaviorRelay<[Menu]>(value: [])
    
    var disposeBag = DisposeBag()
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
//        var menus: [Menu] = [
//            Menu(id: 0, name: "튀김1", price: 100, count: 0),
//            Menu(id: 1, name: "튀김2", price: 100, count: 0),
//            Menu(id: 2, name: "튀김3", price: 100, count: 0),
//        ]
        
        _ = APIService.fetchAllMenusRx()
            .map { data -> [MenuItem] in
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.menus
            }.map{ menuItems -> [Menu] in
                var menus: [Menu] = []
                menuItems.enumerated().forEach { (index, item) in
                    let menu = Menu.fromMenuItems(id: index, item: item)
                    menus.append(menu)
                }
                return menus
            }
            .take(1)
            .bind(to: self.menuObservable)
        
    }
    
    func clearAllItemSlections() {
        menuObservable
            .observe(on: MainScheduler.instance)
            .map{ menus in
                menus.map{ m in
                    Menu(id: m.id, name: m.name, price: m.price, count: 0)
                }
            }.take(1)
            .subscribe(onNext: {
                //self.menuObservable.onNext($0)
                self.menuObservable.accept($0)
            }).disposed(by: disposeBag)
    }
    
    func changeCount(item: Menu, increase: Int) {
        menuObservable
            .observe(on: MainScheduler.instance)
            .map{ menus in
                menus.map { m in
                    if m.id == item.id {
                        return Menu(id: m.id, name: m.name, price: m.price, count: max(m.count + increase, 0))
                        
                    } else {
                        return Menu(id: m.id, name: m.name, price: m.price, count: m.count)
                    }
                }
            }
            .take(1)
            .subscribe(onNext: {
                //self.menuObservable.onNext($0)
                self.menuObservable.accept($0)
            }).disposed(by: disposeBag)
    }
    
    func onOrder() {
        
    }
    
}
