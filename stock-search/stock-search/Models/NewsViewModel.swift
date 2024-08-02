//
//  NewsViewModel.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/20/24.
//

import Foundation
import Alamofire

@Observable
class NewsModel {
    
    var news: [NewsElement] = []
    let currentDate = Date()
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func fetchNews(ticker: String, completion: @escaping () -> Void) {
        let currentdate = formatDate(currentDate)
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = -6
        let pastdate = formatDate(calendar.date(byAdding: dateComponents, to: Date()) ?? Date())
        print("http://localhost:3000/companynews?ticker=\(ticker)&pastdate=\(pastdate)&currentdate=\(currentdate)")
        AF.request("http://localhost:3000/companynews?ticker=\(ticker)&pastdate=\(pastdate)&currentdate=\(currentdate)").responseDecodable(of: [NewsElement].self) { response in
            switch response.result {
            case .success(let value):
                let filteredNews = value.filter { newsItem in
//                    !newsItem.category.isEmpty &&
                    !newsItem.headline.isEmpty &&
                    !newsItem.image.isEmpty &&
//                    !newsItem.related.isEmpty &&
                    !newsItem.source.isEmpty &&
                    !newsItem.summary.isEmpty &&
                    !newsItem.url.isEmpty
                }.prefix(20)

                self.news = Array(filteredNews)
                completion()
            case .failure(let error):
                print("Error fetching company peers: \(error)")
            }
        }
    }
    
    func relativeTimeString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute], from: date, to: now)
        
        guard let hours = components.hour, let minutes = components.minute else {
            return "Just now"
        }
        
        var result = ""
        if hours > 0 {
            result += "\(hours) hr"
        }
        
        if minutes > 0 {
            if !result.isEmpty {
                result += ", "
            }
            result += "\(minutes) min"
        }
        
        if result.isEmpty {
            result = "Just now"
        }
        
        return result
    }
    
    func formatUnixEpochTime(_ epochTime: Int) -> String {
        // Create a Date instance from epoch time
        let date = Date(timeIntervalSince1970: TimeInterval(epochTime))
        
        // Set up the date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"  // Specify the desired format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)  // Adjust timezone if needed
        
        // Format the date to a string and return
        return dateFormatter.string(from: date)
    }
    
}
