//
//  ImageLoadingViewModel.swift
//  Playground
//
//  Created by Jason on 2024/2/20.
//

import Foundation
import SwiftUI
import Combine

@Observable
class ImageLoadingViewModel {
    let urlString: String
    let imageKey: String
    
    // publishing image and isLoading to view
    var image: UIImage? = nil
    var isLoading: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    let manager = PhotoModelCacheManager.instance
    
    init(url: String, key: String) {
        self.urlString = url
        self.imageKey = key
        self.getImage()
    }
    
    func getImage() {
        if let savedImage = manager.get(key: imageKey) {
            image = savedImage
            print("getting saved image in cache")
        } else {
            downloadImage()
        }
    }
    
    func downloadImage() {
        print("Downloading Image now!")
        isLoading = true
        guard let url = URL(string: self.urlString) else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                guard let self = self,
                      let image = returnedImage else { return }
                self.image = image
                self.manager.add(key: self.imageKey, value: image)
            }
            .store(in: &cancellables)
    }
}
