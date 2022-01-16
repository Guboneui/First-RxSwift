//
//  MVVMNewsArticle.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/16.
//

import Foundation

struct MVVMNewsArticleResponse: Decodable {
    let articles: [MVVMNewsArticle]
}

struct MVVMNewsArticle: Decodable {
    let title: String
    let description: String?
}
