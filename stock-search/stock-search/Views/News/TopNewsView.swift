//
//  TopNewsView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/20/24.
//

import SwiftUI

struct TopNewsView: View {
    @State private var showingDetailedNewsSheet = false
    @State var newsModel: NewsModel = NewsModel()
    var ticker: String = ""
    @State private var isLoading = false
    init(ticker: String) {
        self.ticker = ticker
    }
    @State private var chosenItem: NewsElement? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                if isLoading {
                    ProgressView()
                } else if newsModel.news.isEmpty {
                    Text("No news available")
                } else {
                    Text("News")
                        .font(.title2)
                        .padding()
                    
                    if let firstNews = newsModel.news.first {
                    Button(action:  {
                        DispatchQueue.main.async {
                            chosenItem = firstNews
                            showingDetailedNewsSheet.toggle()
                        }
                    }) {
                        VStack(alignment: .leading) {
                            if let url = URL(string: firstNews.image) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                            .cornerRadius(8)
                                        
                                    case .failure:
                                        Image(systemName: "photo.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                    case .empty:
                                        ProgressView()
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                            else {
                                Image(systemName: "photo")
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                            }
                            HStack {
                                Text(firstNews.source)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                let date = Date(timeIntervalSince1970: Double(firstNews.datetime))
                                Text(newsModel.relativeTimeString(from: date))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            HStack(alignment: .top) {
                                Text(firstNews.headline)
                                    .font(.headline)
                                    .lineLimit(2)
                            }
                        }
                        .padding()
                        .background(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(Color.black)
                    .sheet(isPresented: $showingDetailedNewsSheet) {
                        DetailedNewsView(newsItem: firstNews, showingDetailedNewsSheet: $showingDetailedNewsSheet)
                        }
                    }
                    
                    Divider()
                    
                    ForEach(newsModel.news.dropFirst(), id: \.id) { newsItem in
                        Button(action: {
                            chosenItem = newsItem
                            showingDetailedNewsSheet.toggle()
                            print(chosenItem!)
                        }) {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(newsItem.source)
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            let date = Date(timeIntervalSince1970: Double(newsItem.datetime))
                                            Text(newsModel.relativeTimeString(from: date))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        HStack(alignment: .top) {
                                            Text(newsItem.headline)
                                                .font(.headline)
                                                .lineLimit(2)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    Spacer()
                                    if let url = URL(string: newsItem.image) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 80, height: 80)
                                                .clipped()
                                                .cornerRadius(8)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    } else {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 80)
                                            .clipped()
                                            .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                            .cornerRadius(8)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showingDetailedNewsSheet) {
                            if let unwrappedValue = chosenItem {
                                DetailedNewsView(newsItem: unwrappedValue, showingDetailedNewsSheet: $showingDetailedNewsSheet)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingDetailedNewsSheet) {
                if let unwrappedValue = chosenItem {
                    DetailedNewsView(newsItem: unwrappedValue, showingDetailedNewsSheet: $showingDetailedNewsSheet)
                }
            }
        }
        .onAppear {
            isLoading = true
            newsModel.fetchNews(ticker: ticker)
            {
                isLoading = false
            }
        }
    }
}

struct MockData2 {
    static let sampleNewsItem2 = NewsElement(
        datetime: 1713631298,
        headline: "20 Largest Companies in the World by Market Cap in 2024",
        id: 123,
        image: "SampleImageURL",
        source: "Yahoo",
        summary: "Sample Summary",
        url: "https://example.com"
    )
}

#Preview {
    TopNewsView(ticker: "TSLA")
        .environment(NewsModel())
}
