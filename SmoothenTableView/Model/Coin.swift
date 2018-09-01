//
//  Coin.swift
//  SmoothenTableView
//
//  Created by MINATO on 9/1/18.
//  Copyright © 2018 MINATO. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let coin = try? newJSONDecoder().decode(Coin.self, from: jsonData)

import Foundation

struct Coins: Codable {
    let data: [String: CoinElement]?
    let metadata: Metadata?
}

struct CoinElement: Codable {
    let id: Int?
    let name, symbol, websiteSlug: String?
    let rank, circulatingSupply, totalSupply: Int?
    let maxSupply: Int?
    let quotes: Quotes?
    let lastUpdated: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case websiteSlug = "website_slug"
        case rank
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case quotes
        case lastUpdated = "last_updated"
    }
}

struct Quotes: Codable {
    let usd: Usd?
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct Usd: Codable {
    let price, volume24H: Double?
    let marketCap: Int?
    let percentChange1H, percentChange24H, percentChange7D: Double?
    
    enum CodingKeys: String, CodingKey {
        case price
        case volume24H = "volume_24h"
        case marketCap = "market_cap"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
    }
}

struct Metadata: Codable {
    let timestamp, numCryptocurrencies: Int?
    let error: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case numCryptocurrencies = "num_cryptocurrencies"
        case error
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
