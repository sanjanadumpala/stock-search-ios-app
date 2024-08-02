//
//  StockDetailView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/8/24.
//

extension Double {
    func rounded(toDecimalPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

import SwiftUI

struct StockDetailView: View {
    @Environment(StockModel.self) var stockModel: StockModel
    @State private var isLoading = true
    @State private var showingSheet = false
    @State private var showHourly = true
    @State private var watchlistButton = false
    @State private var showaddWatchlistToast: Bool = false
    @State private var showdelWatchlistToast: Bool = false
//    @State var stockModelTrial = StockModel()

    var ticker: String = ""
    init(ticker: String) {
            self.ticker = ticker
        }

    var body: some View {
        ScrollView {
            if !isLoading
            {
                if let description = stockModel.description,
                    let lateststockprice = stockModel.lateststockprice,
                    let companypeers = stockModel.companypeers
                {
                    VStack (alignment: .leading) {
                    // ================================================== BASE INFORMATION ==================================================
                        HStack {
                            VStack (alignment: .leading) {
                                Text(description.ticker)
                                    .font(.largeTitle)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding(5)
                                HStack {
                                    Text(description.name)
                                        .foregroundStyle(.secondary)
                                        .padding(5)
                                    Spacer()
                                    if let url = URL(string: description.logo) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable() // Make the image resizable
                                                    .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                                                    .frame(width: 50, height: 50) // Set a fixed size (e.g., 50x50)
                                                    .cornerRadius(8)
                                                    .padding(.trailing)
                                                
                                            case .failure:
                                                Image(systemName: "photo.fill")
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
                                }
                                HStack {
                                    Text(String(format: "$%.2f", lateststockprice.c))
                                        .font(.title)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    Image(systemName: lateststockprice.d > 0 ? "arrow.up.right" : (lateststockprice.d < 0 ? "arrow.down.right" : "minus"))
                                        .foregroundColor(lateststockprice.d > 0 ? .green : (lateststockprice.d < 0 ? .red : .gray))
                                    Text(String(format: "$%.2f", lateststockprice.d))
                                        .font(.title2)
                                        .foregroundColor(lateststockprice.d > 0 ? .green : (lateststockprice.d < 0 ? .red : .gray))
                                    Text(String(format: "(%.2f%%)", lateststockprice.dp))
                                        .font(.title2)
                                        .foregroundColor(lateststockprice.d > 0 ? .green : (lateststockprice.d < 0 ? .red : .gray))
                                }
                                .padding(5)
                            }
                        }
                        .padding(.leading, 20)

                    // ================================================== HOURLY AND HISTORICAL CHART ==================================================
                        HStack {
                            VStack {
                                HStack {
                                    if (showHourly) {
                                        let color = (lateststockprice.d > 0 ? "green" : (lateststockprice.d < 0 ? "red" : "gray"))
                                        HourlyView(ticker: description.ticker, color: color)
                                            .frame(height: 410)
                                    }
                                    else {
                                        HistoricalView(ticker: description.ticker)
                                            .frame(height: 410)
                                    }
                                }
                                Divider()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        showHourly = true
                                    }) {
                                        VStack {
                                            Image(systemName: "chart.xyaxis.line")
                                                .font(.title2)
                                            Text ("Hourly")
                                                .font(.caption2)
                                        }
                                    }
                                    .foregroundColor(showHourly ? .blue : .gray)
                                    .padding()
                                    Spacer()
                                    Spacer()
                                    Button(action: {
                                        showHourly = false
                                    }) {
                                        VStack {
                                            Image(systemName: "clock.fill")
                                                .font(.title2)
                                            Text("Historical")
                                                .font(.caption2)
                                        }
                                    }
                                    .foregroundColor(showHourly ? .gray : .blue)
                                    .padding()
                                    Spacer()
                                }
                            }
                        }
                        .padding(.top, 0)

                    // ================================================== PORTFOLIO ==================================================
                        HStack {
                            VStack (alignment: .leading) {
                                Text("Portfolio")
                                    .font(.title2)
                                    .padding()
                                HStack {
                                    VStack (alignment: .leading) {
                                        if (stockModel.checkportfolio.isEmpty) {
                                            Text("You have 0 shares of \(description.ticker).")
                                            Text("Start trading!")
                                        }
                                        else {
                                            let difference = ((lateststockprice.c * (Double(stockModel.checkportfolio[0].stocks) ?? 0)).rounded(toDecimalPlaces: 2) - (Double(stockModel.checkportfolio[0].totalcost) ?? 0).rounded(toDecimalPlaces: 2))
                                            (Text("Shares Owned:  ")
                                                .bold()+Text(stockModel.checkportfolio[0].stocks))
                                            .padding(.bottom)
                                            (Text("Avg. Cost / Share:  ")
                                                .bold()+Text(String(format: "$%.2f", ((Double(stockModel.checkportfolio[0].totalcost) ?? 0)/(Double(stockModel.checkportfolio[0].stocks) ?? 0)))))
                                            .padding(.bottom)
                                            (Text("Total Cost:  ")
                                                .bold()+Text("$\(stockModel.checkportfolio[0].totalcost)"))
                                            .padding(.bottom)
                                            (Text("Change:  ")
                                                .bold()+Text(String(format: "$%.2f", difference))
                                                .foregroundColor(difference > 0 ? .green : difference < 0 ? .red : .black))
                                            .padding(.bottom)
                                            (Text("Market Value:  ")
                                                .bold()+Text(String(format: "$%.2f", lateststockprice.c*(Double(stockModel.checkportfolio[0].stocks) ?? 0)))
                                                .foregroundColor(difference > 0 ? .green : difference < 0 ? .red : .black))
                                            .padding(.bottom)
                                        }
                                    }
                                    .font(.subheadline)
                                    .frame(width: UIScreen.main.bounds.width*0.6)
                                    VStack {
                                        Button("Trade") {
                                            showingSheet.toggle()
                                        }
                                        .padding()
                                        .frame(width: UIScreen.main.bounds.width*0.35)
                                        .foregroundColor(Color.white)
                                        .background(Color.green)
                                        .clipShape(Capsule())
                                        .sheet(isPresented: $showingSheet) {
                                            if (stockModel.checkportfolio.isEmpty) {
                                                SheetView(showingSheet: $showingSheet, lsp: lateststockprice.c, wallet: stockModel.getwallet[0].total, ticker: description.ticker, name: description.name, shares: "0", totalcost: "0")
                                            }
                                            else {
                                                SheetView(showingSheet: $showingSheet, lsp: lateststockprice.c, wallet: stockModel.getwallet[0].total, ticker: description.ticker, name: description.name, shares: stockModel.checkportfolio[0].stocks, totalcost: stockModel.checkportfolio[0].totalcost)
                                            }
                                        }
                                    }
                                    .padding(.trailing)
                                    .frame(width: UIScreen.main.bounds.width*0.4)
                                }
                            }
                        }
                        .padding(.top, 0)

                    // ================================================== STATS ==================================================
                        HStack {
                            VStack (alignment: .leading) {
                                Text("Stats")
                                    .font(.title2)
                                    .padding()
                                HStack {
                                    VStack {
                                        (Text("High Price:  ")
                                            .bold()+Text(String(format: "$%.2f", lateststockprice.h)))
                                        .padding(2)
                                        (Text("Low Price:  ")
                                            .bold()+Text(String(format: "$%.2f", lateststockprice.l)))
                                        .padding(2)
                                    }
                                    .padding(.horizontal)
                                    VStack {
                                        (Text("Open Price:  ")
                                            .bold()+Text(String(format: "$%.2f",lateststockprice.o)))
                                        .padding(2)
                                        (Text("Prev. Close:  ")
                                            .bold()+Text(String(format: "$%.2f",lateststockprice.pc)))
                                        .padding(2)
                                    }
                                }
                                .font(.subheadline)
                            }
                        }
                        .padding(.top, 0)

                    // ================================================== ABOUT ==================================================
                        HStack {
                            VStack (alignment: .leading) {
                                Text("About")
                                    .font(.title2)
                                    .padding()
                                HStack {
                                    VStack (alignment: .leading) {
                                        Text("IPO Start Date:")
                                        Text("Industry:")
                                        Text("Webpage:")
                                        Text("Company Peers:")
                                            .padding(.top, 1)
                                    }
                                    .padding(.horizontal)
                                    .fontWeight(.bold)
                                    VStack (alignment: .leading) {
                                        Text(description.ipo)
                                        Text(description.finnhubIndustry)
                                        Button(action: {
                                            if let url = URL(string: description.weburl) {
                                                UIApplication.shared.open(url)
                                            }
                                        }) {
                                            Text(description.weburl)
                                        }
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 20) {
                                                ForEach(companypeers, id: \.self) { item in
                                                    NavigationLink(destination: StockDetailView(ticker: item)) {
                                                        Text("\(item), ")
                                                            .foregroundColor(.blue)
                                                    }
                                                }
                                            }
                                            .padding(0)
                                        }
                                    }
                                }
                                .font(.subheadline)
                            }
                        }
                        .padding(.top, 0)

                    // ================================================== INSIGHTS ==================================================
                        HStack {
                            VStack (alignment: .leading) {
                                Text("Insights")
                                    .font(.title2)
                                    .padding()
                                HStack {
                                    VStack {
                                        Text("Insider Sentiments")
                                            .font(.title2)
                                            .padding(0)
                                        TableView(ticker: description.ticker, name: description.name)
                                    }
                                }
                                HStack {
                                    TrendsView(ticker: description.ticker)
                                        .frame(height: 390)
                                }
                                .padding()
                                HStack {
                                    SurpriseView(ticker: description.ticker)
                                        .frame(height: 390)
                                }
                            }
                        }
                        .padding(.top, 0)

                    // ================================================== NEWS ==================================================
                        HStack {
                            TopNewsView(ticker: description.ticker)
                        }
                        .padding(.top, 0)
                    }
                    .padding()
                }
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("Fetching Data...")
                    .padding(5)
                    .foregroundStyle(.secondary)
                    Spacer()
                }
                .frame(minHeight: UIScreen.main.bounds.height*0.9)
            }
        }
        .toast(isShowing: $showaddWatchlistToast, text: "Adding \(ticker) to Favourites")
        .toast(isShowing: $showdelWatchlistToast, text: "Removing \(ticker) from Favourites")
        .navigationBarTitle(ticker)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: isLoading ? nil :
            Button(action: watchlistToggle){
                VStack {
                    Image(systemName: stockModel.watchlistbutton ? "plus.circle.fill" : "plus.circle" )
                        .font(.body)
                }
            })
        .onAppear() {
            isLoading = true
            stockModel.fetchInitialStockData(ticker: ticker) {
                isLoading = false
                Timer.scheduledTimer(withTimeInterval: 1500, repeats: true) { _ in
                    stockModel.fetchLatestStockPrice(ticker: ticker) {}
                }
            }
        }
    }
    
    func watchlistToggle () {
        stockModel.watchlistbutton.toggle()
        if (stockModel.watchlistbutton == true){
            stockModel.addWatchlist(ticker: ticker) {
                stockModel.fetchWatchlist {
                    showaddWatchlistToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showaddWatchlistToast = false
                    }
                }
            }
        }
        else {
            stockModel.deleteWatchlist(ticker: ticker) {
                stockModel.fetchWatchlist {
                    showdelWatchlistToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showdelWatchlistToast = false
                    }
                }
            }
        }
    }
}

#Preview {
    StockDetailView(ticker: "AAPL")
        .environment(StockModel())
}
