//
//  ToastView.swift
//  stock-search
//
//  Created by Sanjana Kiran Kumar Dumpala on 4/13/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if isShowing {
                Text(text)
                    .padding(25)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.3))
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, text: String) -> some View {
        modifier(ToastModifier(isShowing: isShowing, text: text))
    }
}

//#Preview {
//    ToastModifier(isShowing: .constant(true), text: "Please enter a valid amount")
//}

