//
//  DownloadingImageView.swift
//  Playground
//
//  Created by Jason on 2024/2/20.
//

import SwiftUI

struct DownloadingImageView: View {
    @State var loader: ImageLoadingViewModel
    
    // By initializing with a url and key, this view can be more reusable
    init(url: String, key: String) {
        _loader = State(wrappedValue: ImageLoadingViewModel(url: url, key: key))
    }
    
    var body: some View {
        ZStack {
            if loader.isLoading {
                ProgressView()
            } else if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    DownloadingImageView(url: "https://via.placeholder.com/600/24f355", key: "1")
        .frame(width: 75, height: 75)
}
