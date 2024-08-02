//
//  StockViewModel.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/16/24.
//

import Foundation
import Alamofire

@Observable
class StockModel {
    var description: Description? = nil
    var lateststockprice: LatestStockPrice? = nil
    var portfolio: [PortfolioElement] = []
    var checkportfolio: [CheckPortfolioElement] = []
    var addtoportfolio: [CheckPortfolioElement] = []
    var updateportfolio: [CheckPortfolioElement] = []
    var deletefromportfolio : [CheckPortfolioElement] = []
    var watchlist: [WatchlistElement] = []
    var simplewatchlist: [WatchlistSimpleElement] = []
    var checkwatchlist: [WatchlistSimpleElement] = []
    var getwallet: [Wallet] = []
    var setwallet: [WalletElement] = []
    var sentiment: [Sentiment] = []
    var companypeers: CompanyPeers? = nil
    var watchlistbutton = false

    let currentDate = Date()
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    func fetchDescription(ticker: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/description?ticker=\(ticker)").responseDecodable(of: Description.self) { response in
            switch response.result {
            case .success(let value):
                self.description = value
                completion()
            case .failure(let error):
                print("Error fetching description: \(error)")
            }
        }
    }
    
    func fetchLatestStockPrice(ticker: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/lateststockprice?ticker=\(ticker)").responseDecodable(of: LatestStockPrice.self) { response in
            switch response.result {
            case .success(let value):
                self.lateststockprice = value
                print("latest stock price called")
                completion()
            case .failure(let error):
                print("Error fetching latest stock price: \(error)")
            }
        }
    }
    
    func fetchCompanyPeers(ticker: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/peers?ticker=\(ticker)").responseDecodable(of: CompanyPeers.self) { response in
            switch response.result {
            case .success(let value):
                self.companypeers = value
                completion()
            case .failure(let error):
                print("Error fetching company peers: \(error)")
            }
        }
    }
    
    func fetchSentiment(ticker: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/sentiment?ticker=\(ticker)").responseDecodable(of: [Sentiment].self) { response in
            switch response.result {
            case .success(let value):
                self.sentiment = value
                completion()
            case .failure(let error):
                print("Error fetching company peers: \(error)")
            }
        }
    }
    
    func fetchPortfolio(completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/getportfolio").responseDecodable(of: [PortfolioElement].self) { response in
            switch response.result {
            case .success(let value):
                self.portfolio = value
                completion()
            case .failure(let error):
                print("Error fetching portfolio: \(error)")
            }
        }
    }
    
    func checkPortfolio(ticker: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/checkportfolio?ticker=\(ticker)").responseDecodable(of: [CheckPortfolioElement].self) { response in
            switch response.result {
            case .success(let value):
                self.checkportfolio = value
                completion()
            case .failure(let error):
                print("Error fetching portfolio: \(error)")
            }
        }
    }

    func updatePortfolio(ticker: String, stocks: String, totalcost: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/updateportfolio?ticker=\(ticker)&stocks=\(stocks)&totalcost=\(totalcost)").responseDecodable(of: [CheckPortfolioElement].self) { response in
            switch response.result {
            case .success(let value):
                self.updateportfolio = value
                completion()
            case .failure(let error):
                print("Error fetching portfolio: \(error)")
            }
        }
    }
    
    func addToPortfolio(ticker: String, stocks: String, totalcost: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/addportfolio?ticker=\(ticker)&stocks=\(stocks)&totalcost=\(totalcost)").responseDecodable(of: [CheckPortfolioElement].self) { response in
            switch response.result {
            case .success(let value):
                self.addtoportfolio = value
                completion()
            case .failure(let error):
                print("Error fetching portfolio: \(error)")
            }
        }
    }
    
    func deleteFromPortfolio(ticker: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/deleteportfolio?ticker=\(ticker)").responseDecodable(of: [CheckPortfolioElement].self) { response in
            switch response.result {
            case .success(let value):
                self.deletefromportfolio = value
                completion()
            case .failure(let error):
                print("Error fetching portfolio: \(error)")
            }
        }
    }

    func trial(completion: @escaping () -> Void) {
        print("oopsie")
        completion()
    }
    
    func fetchWatchlist(completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/getwatchlist").responseDecodable(of: [WatchlistElement].self) { response in
            switch response.result {
            case .success(let value):
                self.watchlist = value
                completion()
            case .failure(let error):
                print("Error fetching fetch watchlist: \(error)")
            }
        }
    }
    
    func addWatchlist(ticker: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/addwatchlist?ticker=\(ticker)").responseDecodable(of: [WatchlistSimpleElement].self) { response in
            switch response.result {
            case .success(let value):
                self.simplewatchlist = value
                completion()
            case .failure(let error):
                print("Error fetching add watchlist: \(error)")
            }
        }
    }
    
    func deleteWatchlist(ticker: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/deletewatchlist?ticker=\(ticker)").responseDecodable(of: [WatchlistSimpleElement].self) { response in
            switch response.result {
            case .success(let value):
                self.simplewatchlist = value
                completion()
            case .failure(let error):
                print("Error fetching delete watchlist: \(error)")
            }
        }
    }
    
    func checkWatchlist(ticker: String, completion: @escaping () -> Void) {
        print("http://localhost:3000/checkwatchlist?ticker=\(ticker)")
        AF.request("http://localhost:3000/checkwatchlist?ticker=\(ticker)").responseDecodable(of: [WatchlistSimpleElement].self) { response in
            switch response.result {
            case .success(let value):
                self.checkwatchlist = value
                self.watchlistbutton = !self.checkwatchlist.isEmpty
                completion()
            case .failure(let error):
                print("Error fetching check watchlist: \(error)")
            }
        }
    }
    
    func fetchWallet(completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/getwallet").responseDecodable(of: [Wallet].self) { response in
            switch response.result {
            case .success(let value):
                self.getwallet = value
                completion()
            case .failure(let error):
                print("Error fetching wallet: \(error)")
            }
        }
    }
    
    func setWallet(total: String, completion: @escaping () -> Void) {
        AF.request("http://localhost:3000/setwallet?total=\(total)").responseDecodable(of: [WalletElement].self) { response in
            switch response.result {
            case .success(let value):
                self.setwallet = value
                completion()
            case .failure(let error):
                print("Error fetching wallet: \(error)")
            }
        }
    }
    
    func fetchInitialData(completion: @escaping () -> Void) {
        fetchWatchlist {
            self.fetchPortfolio {
                self.fetchWallet {
                    completion()
                }
            }
        }
    }

    func fetchInitialStockData(ticker: String, completion: @escaping () -> Void) {
        fetchDescription(ticker: ticker) {
            self.checkPortfolio(ticker: ticker) {
                self.checkWatchlist(ticker: ticker) {
                    self.fetchLatestStockPrice(ticker: ticker) {
                        self.fetchWallet {
                            self.fetchCompanyPeers(ticker: ticker) {
                                    completion()
                            }
                        }
                    }
                }
            }
        }
    }
}
