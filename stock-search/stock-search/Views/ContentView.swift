//
//  ContentView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var showSplash: Bool = true
    @Environment(StockModel.self) var stockModel
    @State private var isLoading = true
    @State private var currentDate = Date()
    @StateObject var autocompleteModel = AutocompleteModel()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            VStack {
                NavigationView {
                    Form {
                        // ================================================== AUTOCOMPLETE ==================================================
                        if autocompleteModel.isSearching {
                            Section {
                                List(autocompleteModel.autocompleteResults, id: \.symbol) { result in
                                    NavigationLink(destination: StockDetailView(ticker: result.symbol)) {
                                       HStack {
                                           VStack (alignment: .leading) {
                                                Text(result.symbol)
                                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                Text(result.description)
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                        // ================================================== DATE ==================================================
                            Section {
                                List {
                                    Text(formatter.string(from: currentDate))
                                        .font(.title)
                                        .foregroundStyle(.gray)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .padding(5)
                                }
                            }
                        // ================================================== PORTFOLIO ==================================================
                            Section (header: Text("PORTFOLIO")) {
                                HStack {
                                    List(stockModel.getwallet, id: \.id) { element in
                                        VStack(alignment: .leading) {
                                            Text("Net Worth")
                                            Text("$\(element.totalmarketvalue)")
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        }
                                        Spacer()
                                        VStack(alignment: .leading){
                                            Text("Cash Balance")
                                            Text("$\(element.total)")
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        }
                                    }
                                    .font(.title2)
                                }
                                if (!stockModel.portfolio.isEmpty) {
                                    List {
                                        ForEach(stockModel.portfolio, id: \.ticker) { element in
                                            NavigationLink(destination: StockDetailView(ticker: element.ticker)) {
                                                HStack {
                                                    VStack(alignment: .leading) {
                                                        Text(element.ticker)
                                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                        Text("\(element.stocks) shares")
                                                            .foregroundStyle(.secondary)
                                                    }
                                                    Spacer()
                                                    VStack(alignment: .trailing) {
                                                        Text("$\(element.marketvalue)")
                                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                        HStack {
                                                            Image(systemName: element.change > 0 ? "arrow.up.right" : (element.change < 0 ? "arrow.down.right" : "minus"))
                                                                .foregroundColor(element.change > 0 ? .green : (element.change < 0 ? .red : .gray))
                                                            Text(String(format: "$%.2f", element.change) + String(" ") + String(format: "(%.2f%%)", element.changepercent))
                                                                .font(.subheadline)
                                                                .foregroundColor(element.change > 0 ? .green : (element.change < 0 ? .red : .gray))
//                                                            Text(String(format: "(%.2f%%)", element.changepercent))
//                                                                .font(.subheadline)
//                                                                .foregroundColor(element.change > 0 ? .green : (element.change < 0 ? .red : .gray))
                                                        }
                                                    }
                                                    .padding(3)
                                                }
                                            }
                                        }
                                        .onMove(perform: movePItem)
                                    }
                                }
                            }
                        // ================================================== FAVOURITES ==================================================
                            Section (header: Text("FAVORITES")) {
                                if (!stockModel.watchlist.isEmpty) {
                                    List {
                                        ForEach(stockModel.watchlist, id: \.ticker) { element in
                                            NavigationLink(destination: StockDetailView(ticker: element.ticker)) {
                                                HStack {
                                                    VStack(alignment: .leading) {
                                                        Text(element.ticker)
                                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                        Text(element.name)
                                                            .foregroundStyle(.secondary)
                                                    }
                                                    Spacer()
                                                    VStack(alignment: .trailing) {
                                                        Text(String(format: "$%.2f", element.c))
                                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                        HStack {
                                                            Image(systemName: element.d > 0 ? "arrow.up.right" : (element.d < 0 ? "arrow.down.right" : "minus"))
                                                                .foregroundColor(element.d > 0 ? .green : (element.d < 0 ? .red : .gray))
                                                            Text(String(format: "$%.2f", element.d) + String(" ") + String(format: "(%.2f%%)", element.dp))
                                                                .font(.subheadline)
                                                                .foregroundColor(element.d > 0 ? .green : (element.d < 0 ? .red : .gray))
                                                        }
                                                    }
                                                }
                                                .padding(3)
                                            }
                                        }
                                        .onDelete(perform: deleteItem)
                                        .onMove(perform: moveItem)
                                    }
                                }
                            }
                        // ================================================== FOOTER CREDITS ==================================================
                            Section {
                                List {
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            if let url = URL(string: "https://finnhub.io") {
                                                UIApplication.shared.open(url)
                                            }
                                        }) {
                                            Text("Powered by Finnhub.io")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .padding(7)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .searchable(text: $autocompleteModel.searchText)
                    .navigationBarItems(trailing: EditButton())
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if autocompleteModel.isSearching {
                                Button("Cancel") {
                                    autocompleteModel.cancelSearch()
                                }
                            }
                        }
                    }
                    .navigationTitle("Stocks")
                }
            }
            if showSplash {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(.systemGray5))
                    Image("stockSearchIcon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                }
                .edgesIgnoringSafeArea(.all)
//                .animation(.easeInOut(duration: 0.3))

            }
        }
        .onAppear {
            stockModel.fetchInitialData {}
             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                 withAnimation {
                     showSplash = false
                 }
             }
         }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        stockModel.watchlist.move(fromOffsets: source, toOffset: destination)
    }
    
    func movePItem(from source: IndexSet, to destination: Int) {
        stockModel.portfolio.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteItem(at offsets: IndexSet) {
        let watchlistElementToDelete = offsets.map { stockModel.watchlist[$0].ticker }
        stockModel.deleteWatchlist(ticker: watchlistElementToDelete[0]){}
        stockModel.watchlist.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
        .environment(StockModel())
}
