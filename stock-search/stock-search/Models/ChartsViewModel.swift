//
//  ChartsViewModel.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/16/24.
//

import Foundation
import Alamofire
import SwiftUI

@Observable
class ChartsModel {
    var timehistory: History? = nil
    var filteredtimehistory: FilteredHistory = []
    var history: History? = nil
    var ohlc: FilteredHistory = []
    var vol: FilteredHistory = []
    var trends: [TrendsElement] = []
    var strongbuy: [Int] = []
    var buy: [Int] = []
    var hold: [Int] = []
    var sell: [Int] = []
    var strongsell: [Int] = []
    var dates: [String] = []
    var earning: [EarningElement] = []
    var datessurprise: [String] = []
    var surprise: [Double] = []
    var actual: [Double] = []
    var estimate: [Double] = []
    var title: [String] = []
    var sentiment: [SentimentElement] = []
    var sentimentsum = SentimentData()

    let currentDate = Date()
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func fetchTimeHistoryData(ticker: String, completion: @escaping () -> Void) {
        fetchTimeHistory(ticker: ticker) {
            guard let results = self.timehistory?.results else {
                print("Time history results are nil")
                completion()
                return
            }
        
            self.filteredtimehistory = results.map { result in
                [Double(result.t), result.c]
            }
            completion()
        }
    }
    
    func fetchTimeHistory(ticker: String, completion: @escaping () -> Void) {
        let currentdate = formatDate(currentDate)
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = -2
        let pastdate = formatDate(calendar.date(byAdding: dateComponents, to: Date()) ?? Date())
        AF.request("http://localhost:3000/historytime?ticker=\(ticker)&pastdate=\(pastdate)&currentdate=\(currentdate)").responseDecodable(of: History.self) { response in
            switch response.result {
            case .success(let value):
                self.timehistory = value
                completion()
            case .failure(let error):
                print("Error fetching history: \(error)")
            }
        }
    }
    
    func fetchHistoryData(ticker: String, completion: @escaping () -> Void) {
        fetchHistory(ticker: ticker) {
            guard let results = self.history?.results else {
                print("Time history results are nil")
                completion()
                return
            }
            self.ohlc = results.map { result in
                [Double(result.t), result.o, result.h, result.l, result.c]
            }
            self.vol = results.map { result in
                [Double(result.t), Double(result.v)]
            }
            completion()
        }
    }
    
    func fetchHistory(ticker: String, completion: @escaping () -> Void) {
        let currentdate = formatDate(currentDate)
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -2
        dateComponents.day = -1
        let pastdate = formatDate(calendar.date(byAdding: dateComponents, to: Date()) ?? Date())
        AF.request("http://localhost:3000/history?ticker=\(ticker)&pastdate=\(pastdate)&currentdate=\(currentdate)").responseDecodable(of: History.self) { response in
            switch response.result {
            case .success(let value):
                self.history = value
                completion()
            case .failure(let error):
                print("Error fetching history: \(error)")
            }
        }
    }
    
    func fetchTrends(ticker: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/trends?ticker=\(ticker)").responseDecodable(of: [TrendsElement].self) { response in
            switch response.result {
            case .success(let value):
                self.trends = value
                self.strongbuy = self.trends.map { result in
                    result.strongBuy
                }
                self.buy = self.trends.map { result in
                    result.buy
                }
                self.hold = self.trends.map { result in
                    result.hold
                }
                self.sell = self.trends.map { result in
                    result.sell
                }
                self.strongsell = self.trends.map { result in
                    result.strongSell
                }
                self.dates = self.trends.map { result in
                    String(result.period.prefix(7))
                }
                completion()
            case .failure(let error):
                print("Error fetching company peers: \(error)")
            }
        }
    }
    
    func fetchEarnings(ticker: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/earnings?ticker=\(ticker)").responseDecodable(of: [EarningElement].self) { response in
            switch response.result {
            case .success(let value):
                self.earning = value
                self.datessurprise = self.earning.map { result in
                    result.period
                }
                self.surprise = self.earning.map { result in
                    result.surprise
                }
                self.actual = self.earning.map { result in
                    result.actual
                }
                self.estimate = self.earning.map { result in
                    result.estimate
                }
                self.title = self.earning.map { (result) in
                    "\(result.period)<br/>Surprise: \(result.surprise)"
                }
                completion()
            case .failure(let error):
                print("Error fetching company peers: \(error)")
            }
        }
    }

    func fetchSentiment(ticker: String, completion: @escaping () -> Void){
        AF.request("http://localhost:3000/sentiment?ticker=\(ticker)").responseDecodable(of: Sentiment.self) { response in
            switch response.result {
                case .success(let value):
                    self.sentiment = value.data
                    self.setTableData(response: self.sentiment)
                    completion()
                    
                case .failure(let error):
                    print("Error in fetching sentiments \(error)")
            }
        }
    }

    func setTableData(response: [SentimentElement]) {
        var sum = SentimentData ()
        
        for item in response {
            sum.ct += item.change
            sum.mt += item.mspr
            sum.mt = round(sum.mt * 100) / 100
            
            if item.change > 0 {
                sum.cp += item.change
                sum.cp = round(sum.cp * 100) / 100
            } else {
                sum.cn += item.change
                sum.cn = round(sum.cn * 100) / 100
            }
            
            if item.mspr > 0 {
                sum.mp += item.mspr
                sum.mp = round(sum.mp * 100) / 100
            } else {
                sum.mn += item.mspr
                sum.mn = round(sum.mn * 100) / 100
            }
        }
        self.sentimentsum = sum
    }
}
