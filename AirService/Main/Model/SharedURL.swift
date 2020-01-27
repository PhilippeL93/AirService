//
//  SharedURL.swift
//  AirService
//
//  Created by Philippe on 31/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - extension URL
///    function appendParameters in order to create URL with URLQueryItem
///
extension URL {
    func appendParameters( params: Parameters) -> URL? {
        var components = URLComponents(string: self.absoluteString)
        components?.queryItems = params.map { element in
            URLQueryItem(name: element.key, value: element.value as? String)
        }
        return components?.url
    }
}
