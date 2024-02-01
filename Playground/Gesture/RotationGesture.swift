//
//  RotationGesture.swift
//  Playground
//
//  Created by Jason on 2024/2/1.
//

import SwiftUI

struct RotationGesture: View {
    @State var angle: Angle = Angle(degrees: 0)
    
    var body: some View {
        Text("Hello, World!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(50)
            .background(Color.blue.clipShape(RoundedRectangle(cornerRadius: 10)))
            .rotationEffect(angle)
            .gesture(
                RotateGesture()
                    .onChanged { value in
                        angle = value.rotation
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            angle = Angle(degrees: 0)
                        }
                    }
            )
        
    }
}

#Preview {
    RotationGesture()
}
