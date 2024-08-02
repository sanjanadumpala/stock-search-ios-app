//
//  stock_searchApp.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/3/24.
//

import SwiftUI

@main
struct stock_searchApp: App {
    @State private var stockModel = StockModel()
    @State var newsModel: NewsModel = NewsModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(stockModel)
                .environment(newsModel)

        }
    }
}
