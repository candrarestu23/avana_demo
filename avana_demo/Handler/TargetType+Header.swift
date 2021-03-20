//
//  TargetType+Header.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation
import Moya

extension TargetType {
    func defaultHeader() -> HTTPHeaders {
        var headers: [String: String] = [:]

        let langStr = Locale.preferredLanguages[0]
        let arr = langStr.components(separatedBy: "-")
        let deviceLanguage = arr.first
        headers["Content-Type"] = "application/json"

        return headers
    }
}
