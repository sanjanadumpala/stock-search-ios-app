//
//  BoughtSheetView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/12/24.
//

import SwiftUI

struct BoughtSheetView: View {
    @Environment(StockModel.self) var stockModel: StockModel
    @Binding var showingBoughtSheet: Bool
    @Binding var showingSheet: Bool
    var boughtorsold = ""
    var shares = ""
    var ticker = ""
    var body: some View {
        VStack {
            Spacer()
            Text("Congratulations!")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .padding()
            Text("You have successfully \(boughtorsold) \(shares) \(Int(shares) == 1 ? "share" : "shares") of \(ticker)")
            Spacer()
            Button("Done") {
                stockModel.checkPortfolio(ticker: ticker) {
                    showingSheet = false
                    showingBoughtSheet = false
                }
            }
            .padding(.horizontal, 150)
            .padding(.vertical)
            .foregroundColor(Color.green)
            .background(Color.white)
            .clipShape(Capsule())
            .padding()
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    BoughtSheetView(showingBoughtSheet: .constant(true), showingSheet: .constant(true), boughtorsold: "bought", shares: "1", ticker: "TSLA")
        .environment(StockModel())
}
