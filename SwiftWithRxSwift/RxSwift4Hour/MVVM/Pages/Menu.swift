//
//  Menu.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/30.
//

import Foundation

// Model / View를 위한 모델 -> ViewModel

struct ViewMenu {
    var name: String
    var price: Int
    var count: Int
    
    init(_ item: MenuItem) {
        name = item.name
        price = item.price
        count = 0
    }
    
    init(name: String, price: Int, count: Int) {
        self.name = name
        self.price = price
        self.count = count
    }
    
    func countUpdated(_ count: Int) -> ViewMenu {
        return ViewMenu(name: name, price: price, count: count)
    }
    
    func asMenuItem() -> MenuItem {
        return MenuItem(name: name, price: price)
    }
}


extension ViewMenu: Equatable {
    static func == (lhs: ViewMenu, rhs: ViewMenu) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price && lhs.count == rhs.count
    }
}
