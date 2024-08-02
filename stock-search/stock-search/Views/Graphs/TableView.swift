//
//  TableView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/30/24.
//

import SwiftUI

struct TableView: View {
    @State var chartsModel: ChartsModel = ChartsModel()
    @State private var isLoading = false
    var ticker: String = ""
    var name: String = ""
    
    init(ticker: String, name: String) {
        self.ticker = ticker
        self.name = name
    }

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(name)")
                        .bold()
                        .padding(.vertical, 5)
                    Divider()
                    Text("Total")
                        .bold()
                        .padding(.vertical, 5)
                    Divider()
                    Text("Positive")
                        .padding(.vertical, 5)
                        .bold()
                    Divider()
                    Text("Negative")
                        .padding(.vertical, 5)
                        .bold()
                    Divider()
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("MSPR")
                        .bold()
                        .padding(.vertical, 5)
                    Divider()
                    Text(String(format: "%.2f", chartsModel.sentimentsum.mt))
                        .padding(.vertical, 5)
                    Divider()
                    Text(String(format: "%.2f", chartsModel.sentimentsum.mp))
                        .padding(.vertical, 5)
                    Divider()
                    Text(String(format: "%.2f", chartsModel.sentimentsum.mn))
                        .padding(.vertical, 5)
                    Divider()
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Change")
                        .bold()
                        .padding(.vertical, 5)
                    Divider()
                    Text(String(format: "%.2f", chartsModel.sentimentsum.ct))
                        .padding(.vertical, 5)
                    Divider()
                    Text(String(format: "%.2f", chartsModel.sentimentsum.cp))
                        .padding(.vertical, 5)
                    Divider()
                    Text(String(format: "%.2f", chartsModel.sentimentsum.cn))
                        .padding(.vertical, 5)
                    Divider()
                }
            }
            .padding()
        }
        .onAppear {
            isLoading = true
            chartsModel.fetchSentiment(ticker: ticker)
            {
                isLoading = false
            }
        }
    }

}

#Preview {
    TableView(ticker: "AAPL", name: "Apple Inc")
        .environment(ChartsModel())
}
