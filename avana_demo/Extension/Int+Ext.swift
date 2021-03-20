//
//  Int+Ext.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation
extension Int {
    func dateFromInt() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        return dateFormatter.string(from: date)
    }
}
