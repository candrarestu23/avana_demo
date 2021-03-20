//
//  ResponseHandler.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation
import Moya

class ResponseHandler {

    static func getResponse<T : Decodable> (data: Data) -> T? {
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return response
        } catch let error {
            print("error: \(error)")
        }
        return nil
    }
}
