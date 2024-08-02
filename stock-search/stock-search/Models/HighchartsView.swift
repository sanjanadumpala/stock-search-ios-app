//
//  HighchartsView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/8/24.
//

import SwiftUI
import WebKit

struct HighchartsView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
