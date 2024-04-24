//
//  WebView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
   
    var url: URL
    
    func makeUIView(context: Context) -> some WKWebView {
        let view = WKWebView()
        view.load(URLRequest(url: url))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
