//
//  ArticleViewModel.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/16.
//

import Foundation
import RxSwift
import RxCocoa


struct ArticleListViewModel {
    let articlesVM: [ArticleViewModel]
}

extension ArticleListViewModel {
    init(_ articles: [MVVMNewsArticle]) {
        self.articlesVM = articles.compactMap(ArticleViewModel.init)
    }
}

extension ArticleListViewModel {
    func articleAt(_ index: Int) -> ArticleViewModel {
        return self.articlesVM[index]
    }
}

struct ArticleViewModel {
    let article: MVVMNewsArticle
    
    init(_ article: MVVMNewsArticle) {
        self.article = article
    }
}

extension ArticleViewModel {
    var title: Observable<String> {
        return Observable<String>.just(article.title)
    }
    
    var description: Observable<String> {
        return Observable<String>.just(article.description ?? "")
    }
}
