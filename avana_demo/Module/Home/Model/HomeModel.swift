//
//  HomeModel.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation
struct HomeModel : Codable {
    var internalName: String?
    var title: String?
    var metacriticLink: String?
    var dealID: String?
    var storeID: String?
    var gameID: String?
    var salePrice: String?
    var normalPrice: String?
    var isOnSale: String?
    var savings: String?
    var metaCriticScore: String?
    var steamRatingText: String?
    var steamRatingPercent: String?
    var steamRatingCount: String?
    var steamAppID: String?
    var releaseDate: Int?
    var lastChange: Int?
    var dealRating: String?
    var thumb: String?
    
    enum CodingKeys: String, CodingKey {
        case internalName
        case title
        case metacriticLink
        case dealID
        case storeID
        case gameID
        case salePrice
        case normalPrice
        case isOnSale
        case savings
        case metaCriticScore
        case steamRatingText
        case steamRatingPercent
        case steamRatingCount
        case steamAppID
        case releaseDate
        case lastChange
        case dealRating
        case thumb
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        internalName = try container.decodeIfPresent(String.self, forKey: .internalName)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        metacriticLink = try container.decodeIfPresent(String.self, forKey: .metacriticLink)
        dealID = try container.decodeIfPresent(String.self, forKey: .dealID)
        storeID = try container.decodeIfPresent(String.self, forKey: .storeID)
        gameID = try container.decodeIfPresent(String.self, forKey: .gameID)
        salePrice = try container.decodeIfPresent(String.self, forKey: .salePrice)
        normalPrice = try container.decodeIfPresent(String.self, forKey: .normalPrice)
        isOnSale = try container.decodeIfPresent(String.self, forKey: .isOnSale)
        savings = try container.decodeIfPresent(String.self, forKey: .savings)
        metaCriticScore = try container.decodeIfPresent(String.self, forKey: .metaCriticScore)
        steamRatingText = try container.decodeIfPresent(String.self, forKey: .steamRatingText)
        steamRatingPercent = try container.decodeIfPresent(String.self, forKey: .steamRatingPercent)
        steamRatingCount = try container.decodeIfPresent(String.self, forKey: .steamRatingCount)
        steamAppID = try container.decodeIfPresent(String.self, forKey: .steamAppID)
        releaseDate = try container.decodeIfPresent(Int.self, forKey: .releaseDate)
        lastChange = try container.decodeIfPresent(Int.self, forKey: .lastChange)
        dealRating = try container.decodeIfPresent(String.self, forKey: .dealRating)
        thumb = try container.decodeIfPresent(String.self, forKey: .thumb)
    }
}
