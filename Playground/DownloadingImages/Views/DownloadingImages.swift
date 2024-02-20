//
//  DownloadingImages.swift
//  Playground
//
//  Created by Jason on 2024/2/20.
//

import SwiftUI

// Understanding the following:
/*
 1. background thread
 2. weak self
 3. Combine
 4. Publishers and Subscribers
 5. FileManager
 6. NSCache
 7. Codable Protocol
 */

struct DownloadingImages: View {
    @State var vm = DownloadingImagesViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.dataArray) { model in
                    DownloadingImagesRow(model: model)
                }
            }
            .navigationTitle("Download Images")
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    DownloadingImages()
}
