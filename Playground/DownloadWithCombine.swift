//
//  DownloadWithCombine.swift
//  Playground
//
//  Created by Jason on 2024/1/29.
//

import SwiftUI
import Combine

@Observable
class DownloadWithCombineViewModel {
    
    var posts: [PostModel] = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        // Combine discussion:
        /*
        //1. sign up for monthly subscription for package to be delivered
        //2. the company would make the package behind the scene
        //3. receive the package at your front door
        //4. make sure the box is intact
        //5. open and make sure the item is correct
        //6. use the item
        //7. cancellable at any time
        
        //1. Create the the publisher
        //2. subscribe the publisher onto the background thread
        //3.  receive on main thread
        //4. tryMap (check the data is intact)
        //5. decode (decode data into PostModels)
        //6. sink ( put the item into our app)
        //7. store (cancel subscription if needed)
         */
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .sink { completion in
                print("completion: \(completion)")
            } receiveValue: { [weak self] returnPosts in
                self?.posts = returnPosts
            }
            .store(in: &cancellables)
       
    }
}

struct DownloadWithCombine: View {
    
    @State var vm = DownloadWithCombineViewModel()
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title).font(.headline)
                    Text(post.body).foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    DownloadWithCombine()
}
