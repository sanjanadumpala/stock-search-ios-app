//
//  SheetView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/12/24.
//

import SwiftUI

struct SheetView: View {
    @Binding var showingSheet: Bool
    @State private var showingBoughtSheet: Bool = false
    @State private var showingSoldSheet: Bool = false
    @Environment(StockModel.self) var stockModel: StockModel
    @State private var numberString = ""
    @State private var showNegativeSellToast: Bool = false
    @State private var showNegativeBuyToast: Bool = false
    @State private var showZeroToast: Bool = false
    @State private var showNotEnoghMoneyToast: Bool = false
    @State private var showNotEnoghStocksToast: Bool = false

    var lsp: Double = 0.0
    var wallet: String = ""
    var ticker: String = ""
    var name: String = ""
    var shares: String = ""
    var totalcost: String = ""

    var body: some View {
        let numberValue = Double(numberString) ?? 0
        let lspValue = Double(lsp)
        let walletValue = Double(wallet) ?? 0
        let shareValue = Double(shares) ?? 0
        let totalcostValue = Double(totalcost) ?? 0

        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showingSheet = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            Text("Trade \(name) shares")
                .fontWeight(.bold)
            Spacer()
            HStack (alignment: .bottom){
                VStack {
                    TextField("0", text: $numberString)
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                    .fontWeight(.light)
                    .font(.system(size: 120))
                }
                Spacer()
                VStack (alignment: .trailing) {
                    Text("\(numberValue < 2 ? "Share" : "Shares")")
                        .font(.title)
                        .padding()
                }
            }
            HStack () {
                Spacer()
                Text("x \(String(format: "$%.2f", lspValue))/share = \(String(format: "$%.2f", (lspValue * numberValue)))")
                    .padding()
            }
            Spacer()
            HStack {
                Text("$\(wallet) available to buy \(ticker)")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .padding()
            }
            HStack {
                Spacer()
                Button("Buy") {
                    if (numberValue < 0) {
                        showNegativeBuyToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showNegativeBuyToast = false
                        }
                    }
                    else if (numberValue == 0) {
                        showZeroToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showZeroToast = false
                        }
                    }
                    else {
                        if ((numberValue * lspValue) - walletValue > 0) {
                            showNotEnoghMoneyToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showNotEnoghMoneyToast = false
                            }
                        }
                        else {
                            if (shareValue > 0) {
                                stockModel.updatePortfolio(ticker: ticker, stocks: String(Int(shareValue + numberValue)), totalcost: String(format: "%.2f", (totalcostValue + (lspValue * numberValue)))){
                                    stockModel.setWallet(total: String(format: "%.2f", (walletValue - (lspValue * numberValue)))){
                                        stockModel.fetchPortfolio {
                                            stockModel.fetchWallet {}
                                        }
                                    }
                                }
                            }
                            else {
                                stockModel.addToPortfolio(ticker: ticker, stocks: String(Int(numberValue)), totalcost: String(format: "%.2f", (lspValue * numberValue))){
                                    stockModel.setWallet(total: String(format: "%.2f", (walletValue - (lspValue * numberValue)))){
                                        stockModel.fetchPortfolio {
                                            stockModel.fetchWallet {}
                                        }
                                    }
                                }
                            }
//                            showingSheet = false
                            showingBoughtSheet.toggle()
//                            showingSheet.toggle()
                        }
                    }
                }
                .sheet(isPresented: $showingBoughtSheet) {
                    BoughtSheetView(showingBoughtSheet: $showingBoughtSheet, showingSheet: $showingSheet, boughtorsold: "bought", shares: numberString, ticker: ticker)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width*0.4)
                .foregroundColor(Color.white)
                .background(Color.green)
                .clipShape(Capsule())
                Spacer()
                Button("Sell") {
                    if (numberValue < 0) {
                        showNegativeSellToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showNegativeSellToast = false
                        }
                    }
                    else if (numberValue == 0) {
                        showZeroToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showZeroToast = false
                        }
                    }
                    else {
                        if (numberValue - shareValue > 0) {
                            showNotEnoghStocksToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showNotEnoghStocksToast = false
                            }
                        }
                        else {
                            if (shareValue == numberValue) {
                                stockModel.deleteFromPortfolio(ticker: ticker){
                                    stockModel.setWallet(total: String(format: "%.2f", (walletValue + (lspValue * numberValue)))){
                                        stockModel.fetchPortfolio {
                                            stockModel.fetchWallet {}
                                        }
                                    }
                                }
                            }
                            else {
                                stockModel.updatePortfolio(ticker: ticker, stocks: String(Int(shareValue - numberValue)), totalcost: String(format: "%.2f", (totalcostValue - (lspValue * numberValue)))){
                                    stockModel.setWallet(total: String(format: "%.2f", (walletValue + (lspValue * numberValue)))){
                                        stockModel.fetchPortfolio {
                                            stockModel.fetchWallet {}
                                        }
                                    }
                                }
                            }
//                            showingSheet = false
                            showingSoldSheet.toggle()
//                            showingSheet.toggle()
                        }
                    }
                }
                .sheet(isPresented: $showingSoldSheet) {
                    BoughtSheetView(showingBoughtSheet: $showingSoldSheet, showingSheet: $showingSheet, boughtorsold: "sold", shares: numberString, ticker: ticker)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width*0.4)
                .foregroundColor(Color.white)
                .background(Color.green)
                .clipShape(Capsule())
                Spacer()
            }
        }
        .toast(isShowing: $showNegativeSellToast, text: "Cannot sell non-positive shares")
        .toast(isShowing: $showNegativeBuyToast, text: "Cannot buy non-positive shares")
        .toast(isShowing: $showNotEnoghMoneyToast, text: "Not enough money to buy")
        .toast(isShowing: $showNotEnoghStocksToast, text: "Not enough shares to sell")
        .toast(isShowing: $showZeroToast, text: "Please enter a valid amount")
        
        .onDisappear {
//            print("Modal is being dismissed")
        }
    }
}

#Preview {
    SheetView(showingSheet: .constant(true), lsp: 171.05, wallet: "25000.00", ticker: "AAPL", name: "Apple Inc", shares: "3", totalcost: "5000")
        .environment(StockModel())
}
