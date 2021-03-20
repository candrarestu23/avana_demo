//
//  DetailModel.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation
struct DetailModel : Codable {
    var info: InfoModel?
    var cheapestPriceEver: CheapestPriceModel?
    
    enum CodingKeys: String, CodingKey {
        case info
        case cheapestPriceEver
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        info = try container.decodeIfPresent(InfoModel.self, forKey: .info)
        cheapestPriceEver = try container.decodeIfPresent(CheapestPriceModel.self, forKey: .cheapestPriceEver)
    }
}

struct InfoModel : Codable{
    var title: String?
    var steamAppId: String?
    var thumb: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case steamAppId
        case thumb
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        steamAppId = try container.decodeIfPresent(String.self, forKey: .steamAppId)
        thumb = try container.decodeIfPresent(String.self, forKey: .thumb)
    }
}

struct CheapestPriceModel : Codable{
    var price: String?
    var date: Int?
    
    enum CodingKeys: String, CodingKey {
        case price
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        price = try container.decodeIfPresent(String.self, forKey: .price)
        date = try container.decodeIfPresent(Int.self, forKey: .date)
    }
}
