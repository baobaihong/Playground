//
//  HashablePractice.swift
//  Playground
//
//  Created by Jason on 2024/2/21.
//

import SwiftUI

struct MyCustomModel: Hashable { //  for some reason you don't want to use identifiable, you can use hashable protocol and create a func to generate hash value
    // let id = UUID().uuidString
    let title: String
    // create hash value
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

struct HashablePractice: View {
    let data: [MyCustomModel] = [
        MyCustomModel(title: "ONE"),
        MyCustomModel(title: "TWO"),
        MyCustomModel(title: "THREE"),
        MyCustomModel(title: "FOUR"),
        MyCustomModel(title: "FIVE"),
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40.0) {
                ForEach(data, id: \.self) { item in // you can use self as id because string originally conform to hashable
                    Text(item.hashValue.description)
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    HashablePractice()
}
