//
//  MultipleSheetIssue.swift
//  Playground
//
//  Created by Jason on 2024/2/21.
//

import SwiftUI

struct RandomModel: Identifiable {
    let id = UUID().uuidString
    let title: String
}

/*
 SOLUTION:
 1. use a binding
 2. use multiple .sheet on the same level
 3. use $item if you have a lot of sheet
 */

struct MultipleSheetIssue: View {
    @State var selectedModel: RandomModel? = nil
    @State var showSheet: Bool = false
    @State var showSheet2: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Button 1") {
                selectedModel = RandomModel(title: "One")
//                showSheet.toggle()
            }
            // SOLUTION2: multiple .sheet
//            .sheet(isPresented: $showSheet, content: {
//                NextScreen(selectedModel: RandomModel(title: "One"))
//            })
            Button("Button 2") {
                selectedModel = RandomModel(title: "Two")
//                showSheet2.toggle()
            }
//            .sheet(isPresented: $showSheet2, content: {
//                NextScreen(selectedModel: RandomModel(title: "Two"))
//            })
        }
        // the sheet is created together with the VStack, which at that moment, selectedModel is not changed
        // so when user click the button at once when the screen shows up, they will see 'starting title' instead of 'one' or 'two'
        // WARNING: avoid add any conditional logic inside the sheet
        //        .sheet(isPresented: $showSheet, content: {
        //            NextScreen(selectedModel: selectedModel)
        //        })
        
        // SOLUTION1
//        .sheet(isPresented: $showSheet, content: {
//            NextScreen(selectedModel: $selectedModel)
//        })
        
        //SOLUTION3
        .sheet(item: $selectedModel) { model in
            NextScreen(selectedModel: model)
        }
        
    }
}

struct NextScreen: View {
    
    let selectedModel: RandomModel
    
    var body: some View {
        Text(selectedModel.title)
            .font(.largeTitle)
    }
}

#Preview {
    MultipleSheetIssue()
}
