//
//  AnimationView.swift
//  Playground
//
//  Created by Jason on 2024/2/1.
//

import SwiftUI

struct AnimationView: View {
    @State var isAnimated: Bool = false
    var body: some View {
        VStack {
            Button("Button") {
                withAnimation(
                    Animation
                        .default
                        .repeatForever(autoreverses: true)
                ) {
                    isAnimated.toggle()
                }
            }
            Spacer()
            RoundedRectangle(cornerRadius: isAnimated ? 50 : 25)
                .fill(isAnimated ? Color.red : Color.green)
                .frame(
                    width: isAnimated ? 100 : 300,
                    height: isAnimated ? 100 : 300)
                .rotationEffect(Angle(degrees: isAnimated ? 360 : 0))
                .offset(y: isAnimated ? 300 : 0)
                // not recommended because it will cause unintentional animation
//                .animation(Animation
//                    .default
//                    .repeatForever(autoreverses: true), value: isAnimated)
            Spacer()
        }
    }
}

#Preview {
    AnimationView()
}
