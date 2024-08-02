//
//  AutocompleteViewModel.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/16/24.
//

import Foundation
import SwiftUI
import Combine
import Alamofire
import SwiftyJSON

class AutocompleteModel: ObservableObject {
    @Published var searchText = ""
    @Published var autocompleteResults: [AutocompleteElement] = []
//    @Published var searchResults: [String] = []
    private var cancellables: Set<AnyCancellable> = []
    @Published var isSearching = false
    @Published var autocomplete: Autocomplete? = nil
    
    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] in self?.searchTextChanged($0) }
            .store(in: &cancellables)
    }

    func searchTextChanged(_ query: String) {
        if query.isEmpty {
            // Perform actions when the default "Cancel" button is tapped
            // and the search text is cleared.
            // For example, reset your view or stop showing search results.
            autocompleteResults = []
            isSearching = false

        } else {
            isSearching = true
            // Fetch autocomplete suggestions
            fetchAutocomplete(ticker: query)
        }
    }
    
    func fetchAutocomplete(ticker: String) {
        AF.request("http://localhost:3000/autocomplete?ticker=\(ticker)").responseDecodable(of: Autocomplete.self) { response in
            switch response.result {
            case .success(let value):
                DispatchQueue.main.async {
                    self.autocompleteResults = value.result.filter { element in
                        !element.symbol.contains(".") && element.type == "Common Stock"
                    }
//                    self.autocompleteResults = value.result.filter { !$0.symbol.contains(".") }
                }
            case .failure(let error):
                print("Error fetching autocomplete: \(error)")
            }
        }
    }
    
    func cancelSearch() {
        searchText = ""
        isSearching = false
        autocompleteResults = []
        print(isSearching)
//        searchResults = []
    }
}
