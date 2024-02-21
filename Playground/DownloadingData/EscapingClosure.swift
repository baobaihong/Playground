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
    
    // Iteration1: instant return function
    func downloadData() -> String {
        return "new Data!"
    }
    
    func getData() {
        let newData = downloadData()
        text = newData
    }
    
    // Iteration2: closure data retrieving
    // set a closure as parameter, and call the closure inside the function.
    // completionHandler takes new data as parameter, and change the text attribute.
    func downloadData2(completionHandler: (_ data: String) -> Void) {
        completionHandler("New data!")
    }
    
    func getData2() {
        downloadData2 { returnedData in
            text = returnedData
        }
    }
    
    // Iteration3: simulation of asynchronous data-fetching
    // Asynchronous function returns after it starts the operation, but the closure isn’t called until the operation is completed — the closure needs to escape, to be called later.
    // when asynchronous function need return, use escaping closure instead of return
    func downloadData3(completionHandler: @escaping (_ data: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: DispatchWorkItem(block: {
            completionHandler("new data!")
        }))
    }
    
    func getData3() {
        // Capturing self in an escaping closure makes it easy to accidentally create a strong reference cycle.
        // [weak self] ensures that the reference between closure and class instance is weak instead of strong.
        // so that when waiting for data-fetching, the class instance can be de-initialize.
        downloadData3 { [weak self] data in
            self?.text = data
        }
    }
    
    // Iteration4: define custom closure parameter data type and typealias, more efficient for multiple data type incoming.
    func downloadData4(completionHandler: @escaping DownloadCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: DispatchWorkItem(block: {
            let result = DownloadResult(data: "New Data")
            completionHandler(result)
        }))
    }
    
    func getData4() {
        downloadData4 { [weak self] (returnedData) in
            self?.text = returnedData.data
        }
    }
}

struct DownloadResult {
    let data: String
}

typealias DownloadCompletion = (DownloadResult) -> ()

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
            vm.getData4()
        }
    }
}

#Preview {
    ContentView()
}
