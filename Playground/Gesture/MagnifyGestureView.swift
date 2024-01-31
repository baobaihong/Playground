//
//  MagnifyGesture.swift
//  Playground
//
//  Created by Jason on 2024/1/30.
//

import SwiftUI

struct MagnifyGestureView: View {
    @State var currentAmount: CGFloat = 0
    @State var lastAmount: CGFloat = 0
    
    //    @GestureState private var magnifyBy = 1.0
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Circle().frame(width: 35, height: 35)
                Text("Jason")
                Spacer()
                Image(systemName: "ellipsis")
            }
            .padding(.horizontal)
            
            // simulation of an image
            Rectangle()
                .foregroundStyle(.gray)
                .frame(height: 300)
                .scaleEffect(1 + currentAmount)
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            currentAmount = value.magnification - 1
                        }
                        .onEnded { value in
                            withAnimation(.spring(duration: 0.3)) {
                                currentAmount = 0
                            }
                        }
                )
            
            HStack {
                Image(systemName: "heart.fill")
                Image(systemName: "text.bubble.fill")
                Spacer()
            }
            .padding(.horizontal)
            .font(.headline)
            
            Text("This is the caption for my photo")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
        
        
        //        Text("Hello, World!")
        //            .font(.title)
        //            .padding(40)
        //            .background(Color.red.clipShape(RoundedRectangle(cornerRadius: 10)))
        //            .scaleEffect(1 + currentAmount + lastAmount)
        //            .gesture(
        //                MagnifyGesture()
        //                    .onChanged { value in
        //                        // when the first time user use two finger touching the screen, value.magnification = 1
        //                            currentAmount = value.magnification - 1
        //                    }
        //                    .onEnded { _ in
        //                        // pass the last amount to lastAmount variable
        //                        lastAmount += currentAmount
        //                        // print("lastAmount: \(lastAmount)")
        //                        // reset the currentAmount
        //                        currentAmount = 0
        //                    }
        //                    .updating($magnifyBy, body: { value, gestureState, transaction in
        //                        // print(value.magnification)
        //                        gestureState = value.magnification
        //                    })
        //            )
    }
}

#Preview {
    MagnifyGestureView()
}
