//
//  Article.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/14.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]
}

extension ArticlesList {
    static var all: Resource<ArticlesList> = {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=51ac15cf484c4caa9a51b27a97602024")!
        return Resource(url: url)
    }()
}

struct Article: Decodable {
    let title: String?
    let description: String?
}
