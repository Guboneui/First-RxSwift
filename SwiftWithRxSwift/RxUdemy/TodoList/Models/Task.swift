//
//  Task.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/13.
//

import Foundation

struct Task {
    let title: String
    let priority: Priority
}

enum Priority: Int {
    case high
    case medium
    case low
}
