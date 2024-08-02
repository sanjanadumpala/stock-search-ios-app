//
//  DetailedNewsView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/20/24.
//

import SwiftUI

struct DetailedNewsView: View {
    @Environment(NewsModel.self) var newsModel: NewsModel
    let newsItem: NewsElement
    @Binding var showingDetailedNewsSheet: Bool

    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: {
                    showingDetailedNewsSheet = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            Text(newsItem.source)
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Text(newsModel.formatUnixEpochTime(newsItem.datetime))
                .foregroundStyle(.secondary)
            Divider()
            Text(newsItem.headline)
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)


            Text(newsItem.summary)
                .font(.body)
            
            HStack {
                Text("For more details click")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Button(action: {
                    if let url = URL(string: newsItem.url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("here")
                        .font(.subheadline)
                }
            }
            
            HStack(spacing: 12) {
                Link(destination: URL(string: "https://twitter.com/intent/tweet?text=\(newsItem.headline)&url=\(newsItem.url)")!) {
                    Image("sl_z_072523_61700_05")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35)
                        .foregroundColor(.blue)
                }
                
                Link(destination: URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(newsItem.url)")!) {
                    Image("f_logo_RGB-Blue_144")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 10)
            Spacer()
        }
        .padding()
    }
}

struct MockData {
    static let sampleNewsItem = NewsElement(
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
    DetailedNewsView(newsItem: MockData.sampleNewsItem, showingDetailedNewsSheet: .constant(true))
        .environment(NewsModel())
}
