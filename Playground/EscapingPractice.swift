//
//  ContentView.swift
//  Playground
//
//  Created by Jason on 2024/1/23.
//

import SwiftUI

@Observable
class EscapingViewModel {
    var text: String = "Hello"
    
    func getData() {
        let newData = downloadData()
        text = newData
    }
    
    func downloadData() -> String {
        return "new Data!"
    }
    
}

struct ContentView: View {
    @State var vm = EscapingViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(vm.text)
        }
        .padding()
        .onTapGesture {
            vm.getData()
        }
    }
}

#Preview {
    ContentView()
}
