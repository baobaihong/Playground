//
//  DownloadWithEscaping.swift
//  Playground
//
//  Created by Jason on 2024/1/26.
//

import SwiftUI

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

@Observable
class DownloadWithEscapingViewModel {
    var posts: [PostModel] = []
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        downloadData(fromURL: url) { returnedData in
            if let data = returnedData {
                // all the checks above approved.
                guard let newPosts = try? JSONDecoder().decode([PostModel].self, from: data) else { return }
                // dataTasks runs default on background thread, and you need to update UI only on main thread.
                DispatchQueue.main.async { [weak self] in
                    self?.posts = newPosts
                }
            } else {
                print("No data returned.")
            }
        }
    }
    
    // create a generic function that fetch data from any url.
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> Void) {
        // URLSession.shared provides a shared singleton session object that gives default behavior for creating tasks.
        // completionHandler calls when the load request is complete. This handler is executed on the delegate queue.
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                // check data availability
                let data = data,
                // check if there's any network error
                error == nil,
                // check if the response type is HTTPURLResponse and response code
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                print("Error downloading data.")
                // still call completionHandler if there's any error, passing in nil as parameter.
                completionHandler(nil)
                return
            }
            // if data fetching is successful, call the completionHandler.
            completionHandler(data)
        }.resume()
        // after creating the task, resume() method must be called to start the task.
        // The task calls methods on the session's delegate to provide you with the response metadata, response data, and so on.
    }
}

struct DownloadWithEscaping: View {
    @State var vm = DownloadWithEscapingViewModel()
    
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
    DownloadWithEscaping()
}
