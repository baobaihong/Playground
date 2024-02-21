//
//  WeakSelf.swift
//  Playground
//
//  Created by Jason on 2024/1/29.
//

import SwiftUI

struct WeakSelf: View {
    // store the count of view model instance
    @AppStorage("count") var count: Int?
    
    init() {
        count = 0
    }
    
    var body: some View {
        
        // NavigationStack behaves different from NavigationView, the child view get de-init instantly when not needed.
        NavigationStack {
            NavigationLink("Navigate", destination: WeakSelfSecondScreen())
                .navigationTitle("Screen 1")
        }
        .overlay(alignment: .topTrailing) {
            Text("\(count ?? 0)")
                .font(.largeTitle)
                .padding()
                .background(Color.green.cornerRadius(10))
        }
    }
}

struct WeakSelfSecondScreen: View {
    // the second view creates a vm instance because it's using the data inside to display
    // when user navigate back to the previous view, the vm model will deinit automatically
    @StateObject var vm = WeakSelfSecondScreenViewModel()
    
    var body: some View {
        Text("Second View")
            .font(.largeTitle)
            .foregroundStyle(.red)
        
        if let data = vm.data {
            Text(data)
        }
    }
}


class WeakSelfSecondScreenViewModel: ObservableObject {
    
    @Published var data: String? = nil
    
    init() {
        print("Initialize Now")
        // recording numbers of alive instance
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        getData()
    }
    
    // de-init don't need parameter clause
    deinit {
        print("De-initialize Now")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    func getData() {
        // if you create a async code and use self to specify the class instance, it will keep the instance alive to because the background task needs it
        // create a strong reference and keep vm instance even if user no longer need it(i.e. navigate back to the previous view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 500, execute: DispatchWorkItem(block: { [weak self] in
            self?.data = "New Data"
        }))
    }
}

#Preview {
    WeakSelf()
}
