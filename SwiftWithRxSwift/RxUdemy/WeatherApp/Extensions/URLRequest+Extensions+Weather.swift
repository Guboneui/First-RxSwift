//
//  URLRequest+Extensions.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/16.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
    
}

extension URLRequest {
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }.asObservable()
    }
}
