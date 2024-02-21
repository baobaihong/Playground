//
//  MaskPractice.swift
//  Playground
//
//  Created by Jason on 2024/2/21.
//

// Use .mask modifier to create a 5-star rating animation
// the mask is just like mask tool in design tools like Figma/Sketch
import SwiftUI

struct MaskPractice: View {
    @State var rating: Int = 0
    
    var body: some View {
        ZStack {
            starsView
                .overlay(overlayView.mask(starsView))
        }
    }
    
    private var overlayView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(LinearGradient(colors: [Color.red, Color.blue], startPoint: .leading, endPoint: .trailing))
                    //.foregroundStyle(.yellow)
                    .frame(width: CGFloat(rating) / 5 * geometry.size.width)
            }
        }
        .allowsHitTesting(false)
    }
    
    private var starsView: some View {
        HStack {
            ForEach(1..<6) { index in
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)
                    .onTapGesture {
                        withAnimation(.spring) {
                            rating = index
                        }
                    }
            }
        }
    }
}



#Preview {
    MaskPractice()
}
