//
//  DragGestureView2.swift
//  Playground
//
//  Created by Jason on 2024/2/1.
//

import SwiftUI

struct DragGestureView2: View {
    @State var offsetY: CGFloat = UIScreen.main.bounds.height * 0.83
    @State var currentDragOffsetY: CGFloat = 0
//    @State var endingOffsetY: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            MySignupView()
                .offset(y: offsetY + currentDragOffsetY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.spring()) {
                                currentDragOffsetY = value.translation.height
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                if currentDragOffsetY < -150 {
                                    offsetY = 0
                                } else if currentDragOffsetY > 150 {
                                    offsetY = UIScreen.main.bounds.height * 0.83
                                }
                                currentDragOffsetY = 0
                            }
                        }
                )
            
            Text("\(currentDragOffsetY)")
            
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    DragGestureView2()
}

struct MySignupView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chevron.up")
                .padding(.top)
            Text("Sign up")
                .font(.headline)
                .fontWeight(.semibold)
            
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("This is the description for our app. This is my favorite SwiftUI course and I recommend to all of my friends to subsscribe to Swiftful Thinking!")
                .multilineTextAlignment(.center)
            
            Text("CREATE AN ACCOUNT")
                .foregroundStyle(.white)
                .font(.headline)
                .padding()
                .padding(.horizontal)
                .background(Color.black.clipShape(RoundedRectangle(cornerRadius: 10)))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}
