//
//  URLRequest+Extensions+MVVM.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/16.
//

import Foundation
import RxSwift
import RxCocoa

struct MVVMResource<T: Decodable> {
    let url: URL
}

extension URLRequest {
    static func mvvmLoad<T>(resource: MVVMResource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}
