//
//  EndPointType.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol EndpointType {
    var method: HTTPMethod { get }
    var endPoint: String { get }
    var path: String { get }
    var param: Parameters { get }
    var header: HTTPHeaders { get }
    var isAlertActive: Bool { get }
}

extension EndpointType {
    func defaultHeader() -> HTTPHeaders {
        let langStr = Locale.preferredLanguages[0]
        let arr = langStr.components(separatedBy: "-")
        let deviceLanguage = arr.first

        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        return headers
    }
}
