//
//  MenuListViewModel.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/30.
//

import Foundation
import RxSwift
import RxRelay

protocol MenuFetchable {
    func fetchMenus() -> Observable<[MenuItem]>
}

class MenuStore: MenuFetchable {
    func fetchMenus() -> Observable<[MenuItem]> {
        struct Response: Decodable {
            let menus: [MenuItem]
        }

        return APIService.fetchAllMenusRx()
            .map { data in
                guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
                    throw NSError(domain: "Decoding error", code: -1, userInfo: nil)
                }
                return response.menus
            }
    }
}



// 모든 데이터에 대한 처리는 ViewModel에서 처리한다.


protocol MenuViewModelType {
    var fetchMenus: AnyObserver<Void> { get }
    var clearSelections: AnyObserver<Void> { get }
    var makeOrder: AnyObserver<Void> { get }
    var increaseMenuCount: AnyObserver<(menu: ViewMenu, inc: Int)> { get }
    
    var activated: Observable<Bool> { get }
    var errorMessage: Observable<NSError> { get }
    var allMenus: Observable<[ViewMenu]> { get }
    var totalSelectedCountText: Observable<String> { get }
    var totalPriceText: Observable<String> { get }
    var showOrderPage: Observable<[ViewMenu]> { get }
}

class MenuListViewModel: MenuViewModelType {
    
    // 프로토콜로 선언한 뷰모델 타입을 통해서 기본 구성 요소들을 선언한다.
    let disposeBag = DisposeBag()
    
    // MARK: - InPut -> 서버 또는 특정 액션을 통해서 들어오는 값
    var fetchMenus: AnyObserver<Void>
    var clearSelections: AnyObserver<Void>
    var makeOrder: AnyObserver<Void>
    var increaseMenuCount: AnyObserver<(menu: ViewMenu, inc: Int)>
   
    // MARK: - OutPut -> 실질적으로 사용자에게 보여지는 값
    var activated: Observable<Bool>
    var errorMessage: Observable<NSError>
    var allMenus: Observable<[ViewMenu]>
    var totalSelectedCountText: Observable<String>
    var totalPriceText: Observable<String>
    var showOrderPage: Observable<[ViewMenu]>
 
    init(domain: MenuFetchable = MenuStore()) {
        let fetching = PublishSubject<Void>()
        let clearing = PublishSubject<Void>()
        let ordering = PublishSubject<Void>()
        let incleasing = PublishSubject<(menu: ViewMenu, inc: Int)>()
        
        let menus = BehaviorSubject<[ViewMenu]>(value: [])
        let activating = BehaviorSubject<Bool>(value: false)
        let error = PublishSubject<Error>()
        
        fetchMenus = fetching.asObserver()
        fetching
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchMenus)
            .map{$0.map { ViewMenu($0)}}
            .do(onNext: { _ in activating.onNext(false)})
            .do(onError: { err in error.onNext(err)})
            .subscribe(onNext: menus.onNext)
            .disposed(by: disposeBag)
     
                clearSelections = clearing.asObserver()

                clearing.withLatestFrom(menus)
                    .map { $0.map { $0.countUpdated(0) } }
                    .subscribe(onNext: menus.onNext)
                    .disposed(by: disposeBag)

                makeOrder = ordering.asObserver()

                increaseMenuCount = incleasing.asObserver()

                incleasing.map { $0.menu.countUpdated(max(0, $0.menu.count + $0.inc)) }
                    .withLatestFrom(menus) { (updated, originals) -> [ViewMenu] in
                        originals.map {
                            guard $0.name == updated.name else { return $0 }
                            return updated
                        }
                    }
                    .subscribe(onNext: menus.onNext)
                    .disposed(by: disposeBag)

                // OUTPUT

                allMenus = menus

                activated = activating.distinctUntilChanged()

                errorMessage = error.map { $0 as NSError }

                totalSelectedCountText = menus
                    .map { $0.map { $0.count }.reduce(0, +) }
                    .map { "\($0)" }

                totalPriceText = menus
                    .map { $0.map { $0.price * $0.count }.reduce(0, +) }
                    .map { $0.currencyKR() }

                showOrderPage = ordering.withLatestFrom(menus)
                    .map { $0.filter { $0.count > 0 } }
                    .do(onNext: { items in
                        if items.count == 0 {
                            let err = NSError(domain: "No Orders", code: -1, userInfo: nil)
                            error.onNext(err)
                        }
                    })
                    .filter { $0.count > 0 }
    }
    
    
}



//class MenuListViewModel {

    // UI와 연결된 서브젝트는 에러가 난다고 해서 스트림이 끊어지면 안됨 -> UI에서도 끊어지기 때문에
    // 따라서 Subject도 끊어지면 안됨
    // cocoa에서는 drive
    // subject 에서는 relay
    //var menuObservable = BehaviorSubject<[Menu]>(value: [])
    // subject에서는 next, error, completed 를 뱉어내지만
    // relay에서는 내보내기만 하기 때문에 onNext가 아닌 accept를 사용한다.
//    
//    var menuObservable = BehaviorRelay<[Menu]>(value: [])
//    
//    var disposeBag = DisposeBag()
//    //var itemsCount: Int = 5
//    //var totalPrice: PublishSubject<Int> = PublishSubject()
//    
//    lazy var itemCount = menuObservable.map {
//        $0.map { $0.count }.reduce(0, +)
//    }
//    
//    lazy var totalPrice = menuObservable.map {
//        $0.map{ $0.price * $0.count }.reduce(0, +)
//    }
//    
//    // subject
//    // 서브젝트는 옵저버블 처럼 구독해서 값을 받을수도 있지만, 외부에서 값을 통제할 수 도 있다.
//
//    init() {
////        var menus: [Menu] = [
////            Menu(id: 0, name: "튀김1", price: 100, count: 0),
////            Menu(id: 1, name: "튀김2", price: 100, count: 0),
////            Menu(id: 2, name: "튀김3", price: 100, count: 0),
////        ]
//        
//        _ = APIService.fetchAllMenusRx()
//            .map { data -> [MenuItem] in
//                struct Response: Decodable {
//                    let menus: [MenuItem]
//                }
//                let response = try! JSONDecoder().decode(Response.self, from: data)
//                return response.menus
//            }.map{ menuItems -> [Menu] in
//                var menus: [Menu] = []
//                menuItems.enumerated().forEach { (index, item) in
//                    let menu = Menu.fromMenuItems(id: index, item: item)
//                    menus.append(menu)
//                }
//                return menus
//            }
//            .take(1)
//            .bind(to: self.menuObservable)
//        
//    }
//    
//    func clearAllItemSlections() {
//        menuObservable
//            .observe(on: MainScheduler.instance)
//            .map{ menus in
//                menus.map{ m in
//                    Menu(id: m.id, name: m.name, price: m.price, count: 0)
//                }
//            }.take(1)
//            .subscribe(onNext: {
//                //self.menuObservable.onNext($0)
//                self.menuObservable.accept($0)
//            }).disposed(by: disposeBag)
//    }
//    
//    func changeCount(item: Menu, increase: Int) {
//        menuObservable
//            .observe(on: MainScheduler.instance)
//            .map{ menus in
//                menus.map { m in
//                    if m.id == item.id {
//                        return Menu(id: m.id, name: m.name, price: m.price, count: max(m.count + increase, 0))
//                        
//                    } else {
//                        return Menu(id: m.id, name: m.name, price: m.price, count: m.count)
//                    }
//                }
//            }
//            .take(1)
//            .subscribe(onNext: {
//                //self.menuObservable.onNext($0)
//                self.menuObservable.accept($0)
//            }).disposed(by: disposeBag)
//    }
//    
//    func onOrder() {
//        
//    }
//    
//}
