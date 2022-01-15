//
//  URL+Extensions.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/16.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=665a6e2bb209f6234cdac5bfbb6d28fd")!
    }
}
