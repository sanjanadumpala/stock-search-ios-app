//
//  DataModel.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/7/24.
//

import Foundation

// MARK: - Description
struct Description: Codable {
    let country, currency, estimateCurrency, exchange: String
    let finnhubIndustry, ipo: String
    let logo: String
    let marketCapitalization: Double
    let name, phone: String
    let shareOutstanding: Double
    let ticker: String
    let weburl: String
}

// MARK: - LatestStockPrice
struct LatestStockPrice: Codable {
    let c, d, dp, h: Double
    let l, o, pc: Double
    let t: Int
}

// MARK: - History
struct History: Codable {
    let ticker: String
    let queryCount, resultsCount: Int
    let adjusted: Bool
    let results: [Result]
    let status, requestID: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case ticker, queryCount, resultsCount, adjusted, results, status
        case requestID = "request_id"
        case count
    }
}

// MARK: - Result
struct Result: Codable {
    let v: Int
    let vw, o, c, h: Double
    let l: Double
    let t, n: Int
}

typealias FilteredHistory = [[Double]]

// MARK: - PortfolioElement
struct PortfolioElement: Codable {
    let c, d, dp, h: Double
    let l, o, pc: Double
    let t: Int
    let ticker, stocks, totalcost, marketvalue: String
    let change, changepercent: Double
}

// MARK: - CheckPortfolioElement
struct CheckPortfolioElement: Codable {
    let id, ticker, stocks, totalcost: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ticker, stocks, totalcost
    }
}

// MARK: - WatchlistElement
struct WatchlistElement: Codable {
    let c, d, dp, h: Double
    let l, o, pc: Double
    let t: Int
    let ticker, name: String
}

// MARK: - WatchlistSimpleElement
struct WatchlistSimpleElement: Codable {
    let id, ticker: String
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ticker
    }
}

// MARK: - GetWalletElement
struct Wallet: Codable {
    let id, key, total, totalmarketvalue: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case key, total, totalmarketvalue
    }
}

// MARK: - SetWalletElement
struct WalletElement: Codable {
    let id, key, total: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case key, total
    }
}

// MARK: - Autocomplete
struct Autocomplete: Codable {
    let count: Int
    let result: [AutocompleteElement]
}

// MARK: - AutocompleteElement
struct AutocompleteElement: Codable {
    let description, displaySymbol, symbol: String
    let type: String
    let primary: [String]?
}

// MARK: - CompanyPeers
typealias CompanyPeers = [String]

// MARK: - EarningElement
struct EarningElement: Codable {
    let actual, estimate: Double
    let period: String
    let quarter: Int
    let surprise, surprisePercent: Double
    let symbol: String
    let year: Int
}

// MARK: - TrendsElement
struct TrendsElement: Codable {
    let buy, hold: Int
    let period: String
    let sell, strongBuy, strongSell: Int
    let symbol: String
}

// MARK: - NewsElement
struct NewsElement: Codable {
    let datetime: Int
    let headline: String
    let id: Int
    let image: String
    let source: String
    let summary: String
    let url: String
}

extension NewsElement: Equatable {
    static func ==(lhs: NewsElement, rhs: NewsElement) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SentimentElement: Decodable {
    let symbol: String
    let year, month, change: Double
    let mspr: Double
}

struct Sentiment: Decodable {
    let data: [SentimentElement]
    let symbol: String
}

struct SentimentData: Decodable {
    var mt: Double = 0
    var mp: Double = 0
    var mn: Double = 0
    var ct: Double = 0
    var cp: Double = 0
    var cn: Double = 0
}
