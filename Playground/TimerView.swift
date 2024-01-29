//
//  TimerView.swift
//  Playground
//
//  Created by Jason on 2024/1/29.
//

import SwiftUI

struct TimerView: View {
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    // Current Time
    /*
    @State var currentDate: Date = Date()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .full
        return formatter
    }
     */
    
    // Countdown
    @State var count: Int = 10
    @State var finishedText: String? = nil
    
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))]),
                center: .center,
                startRadius: 5,
                endRadius: 500)
            .ignoresSafeArea()
            
            Text(finishedText ?? "\(count)")
                .font(.system(size: 100, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
        }
        .onReceive(timer, perform: { _ in
            if count <= 1 {
                finishedText = "Boom!!"
            } else {
                count -= 1
            }
        })
    }
}

#Preview {
    TimerView()
}
