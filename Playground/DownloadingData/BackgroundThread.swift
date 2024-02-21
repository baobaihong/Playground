//
//  BackgroundThread.swift
//  Playground
//
//  Created by Jason on 2024/1/29.
//

import SwiftUI

@Observable
class BackgroundThreadViewModel {
    var dataArray: [String] = []
    
    func fetchData() {
        // when moving code into background thread, you need to explicitly reference the class by calling self.
        DispatchQueue.global(qos: .background).async {
            let newData = self.downloadData()
            // put the code that updates the UI into the main thread.
            // check which thread you're on
            print("check1: \(Thread.isMainThread)")
            print("check1: \(Thread.current)")
            
            DispatchQueue.main.async {
                self.dataArray = newData
                print("check2: \(Thread.isMainThread)")
                print("check2: \(Thread.current)")
                
            }
            
        }
    }
    
    private func downloadData() -> [String] {
        var data: [String] = []
        
        for x in 0..<100 {
            data.append("\(x)")
            print(data)
        }
        
        return data
    }
}

struct BackgroundThread: View {
    @State var vm = BackgroundThreadViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                Text("Load Data")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        vm.fetchData()
                    }
                
                ForEach(vm.dataArray, id: \.self) { item in
                    Text(item)
                        .font(.headline)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}

#Preview {
    BackgroundThread()
}

