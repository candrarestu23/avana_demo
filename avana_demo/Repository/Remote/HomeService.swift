//
//  HomeService.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation
import Moya

enum HomeService {
    case getHomeData(_ storeId: Int, _ pageNumber: Int, _ pageSize: Int, _ upperPrice: Int)
    case getDetail(_ id: Int)
}

extension HomeService: TargetType {
    var headers: [String : String]? {
        let headers: HTTPHeaders = defaultHeader()
        return headers
    }
    
    var baseURL: URL {
        switch self {
        case .getHomeData, .getDetail:
            return URL(string: Constant.baseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .getHomeData:
            return "deals"
        case .getDetail:
            return "games"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHomeData, .getDetail:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getHomeData(let storeId, let pageNumber, let pageSize, let upperPrice):
            var params: [String:Any] = [:]
            
            params["storeID"] = storeId
            params["pageNumber"] = pageNumber
            params["pageSize"] = pageSize
            params["upperPrice"] = upperPrice
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        
        case .getDetail(let id):
            var params: [String:Any] = [:]
            
            params["id"] = id
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}
