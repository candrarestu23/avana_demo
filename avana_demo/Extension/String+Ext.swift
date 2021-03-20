//
//  String+Ext.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation

extension String {
    var toUrl: URL? {
        guard let encoded = addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return nil }
        return URL(string: encoded)
    }
}
