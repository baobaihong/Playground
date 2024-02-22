//
//  SortFilterMap.swift
//  Playground
//
//  Created by Jason on 2024/2/21.
//

import SwiftUI

struct UserModel: Identifiable {
    let id = UUID().uuidString
    let name: String?
    let points: Int
    let isVerified: Bool
}

@Observable
class ViewModel {
    var dataArray: [UserModel] = []
    var filtered: [UserModel] = []
    var mapped: [String] = []
    
    init() {
        getusers()
        updateFilteredArray()
    }
    
    func getusers() {
        let user1 = UserModel(name: "Jason", points: 5, isVerified: true)
        let user2 = UserModel(name: "Chris", points: 0, isVerified: false)
        let user3 = UserModel(name: nil, points: 20, isVerified: true)
        let user4 = UserModel(name: "Emily", points: 20, isVerified: false)
        let user5 = UserModel(name: "Samantha", points: 50, isVerified: true)
        let user6 = UserModel(name: "Sarah", points: 45, isVerified: false)
        let user7 = UserModel(name: nil, points: 23, isVerified: true)
        let user8 = UserModel(name: "Steve", points: 76, isVerified: false)
        let user9 = UserModel(name: "Nick", points: 1, isVerified: true)
        let user10 = UserModel(name: "Amanda", points: 100, isVerified: false)
        self.dataArray.append(contentsOf: [user1, user2, user3, user4, user5, user6, user7, user8, user9, user10])
    }
    
    func updateFilteredArray() {
        // sort
        /*
//        let sorted = dataArray.sorted { user1, user2 -> Bool in
//            return user1.points > user2.points
//        }
        filtered = dataArray.sorted(by: { $0.points > $1.points }) // <- shorter way of writing code
         */
        // filter
        /*
//        filtered = dataArray.filter({ user -> Bool in
//            return user.name.contains("i")
//        })
        filtered = dataArray.filter({ $0.isVerified }) // shorter way of writing code
         */
        // map: map to another data model
        /*
//        mapped = dataArray.map({ user -> String in
//            return user.name
//        })
//        mapped = dataArray.map({ $0.name })
        // use .compactMap for optional property
        mapped = dataArray.compactMap({ user -> String? in
            return user.name
        })
         */
        
        // combine multiple approaches
        mapped = dataArray
            .sorted(by: { $0.points > $1.points })
            .filter({ $0.isVerified })
            .compactMap({ $0.name })
    }
}

struct SortFilterMap: View {
    @State var vm = ViewModel()
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(vm.mapped, id: \.self) { name in
                    Text(name).font(.title)
                }
//                ForEach(vm.filtered) { user in
//                    VStack(alignment: .leading) {
//                        Text(user.name)
//                            .font(.headline)
//                        HStack {
//                            Text("Points: \(user.points)")
//                            Spacer()
//                            if user.isVerified {
//                                Image(systemName: "flame.fill")
//                            }
//                        }
//                    }
//                    .foregroundStyle(.white)
//                    .padding()
//                    .background(Color.blue.clipShape(RoundedRectangle(cornerRadius: 10)))
//                    .padding(.horizontal)
//                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    SortFilterMap()
}
