//
//  TransitionView.swift
//  Playground
//
//  Created by Jason on 2024/2/1.
// transition can animate the view that's not shown yet.

import SwiftUI

struct TransitionView: View {
    @State var showView: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            VStack {
                Button("BUTTON") {
                    withAnimation(.spring(duration: 0.3)) {
                        showView.toggle()
                    }
                }
                Spacer()
            }
            
            if showView {
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
//                    .transition(.slide)
//                    .transition(.move(edge: .bottom))
//                    .transition(.opacity)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .opacity))
            }
            
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    TransitionView()
}
