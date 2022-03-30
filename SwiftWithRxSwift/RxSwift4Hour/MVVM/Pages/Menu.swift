//
//  Menu.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/30.
//

import Foundation

// Model / View를 위한 모델 -> ViewModel

struct Menu {
    var id: Int
    var name: String
    var price: Int
    var count: Int
}

extension Menu {
    static func fromMenuItems(id: Int, item: MenuItem) -> Menu {
        return Menu(id: id, name: item.name, price: item.price, count: 0)
    }
}
