//
//  LongPressGesture.swift
//  Playground
//
//  Created by Jason on 2024/1/30.
//

import SwiftUI

struct LongPressGesture: View {
    
    @State var isComplete: Bool = false
    @State var isSuccess: Bool = false
    
    var body: some View {
        
        VStack {
            Rectangle()
                .fill(isComplete ? Color.green : Color.blue)
                .frame(maxWidth: isComplete ? .infinity : 0)
                .frame(height: 55)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray)
            
            HStack {
                Text("CLICK HERE")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onLongPressGesture(minimumDuration: 1.0, maximumDistance: 50) {
                        // at the min duration
                        // when user press 1 sec, success = true
                        withAnimation(.easeInOut) {
                            isSuccess = true
                        }
                    } onPressingChanged: { isPressing in
                        // start of press -> min duration
                        // isPressing is a bool that indicates that user is pressing
                        if isPressing {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                isComplete = true
                            }
                        } else {
                            // if user press less than 1 sec, bounce back
                            // delay the bounce back check a little bit to make sure that when user pressed exactly 1 sec, isSuccess = true is performed
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: DispatchWorkItem(block: {
                                if !isSuccess {
                                    withAnimation(.easeInOut) {
                                        isComplete = false
                                    }
                                }
                            }))
                        }
                    }

                
                Text("RESET")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSuccess = false
                            isComplete = false
                        }
                    }
            }
        }
        
        //        Text(isComplete ? "COMPLETED" : "NOT COMPLETE")
        //            .padding()
        //            .padding(.horizontal)
        //            .background(isComplete ? Color.green : Color.gray)
        //            .clipShape(RoundedRectangle(cornerRadius: 10))
        ////            .onTapGesture {
        ////                isComplete.toggle()
        ////            }
        //        // long press to preform, minimumDuration to set the minimum press time, and maximumdistance to set the maximum distance that user can move away
        //            .onLongPressGesture(minimumDuration: 1.0, maximumDistance: 1) {
        //                isComplete.toggle()
        //            }
    }
}

#Preview {
    LongPressGesture()
}
