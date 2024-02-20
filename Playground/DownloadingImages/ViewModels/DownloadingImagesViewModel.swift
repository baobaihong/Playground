//
//  DownloadingImagesViewModel.swift
//  Playground
//
//  Created by Jason on 2024/2/20.
//

import Foundation
import Combine

@Observable class DownloadingImagesViewModel {
    var dataArray: [PhotoModel] = []
    let dataService = PhotoModelDataService.instance
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$photoModels
            .sink { [weak self] returnedPhotoModels in
                self?.dataArray = returnedPhotoModels
            }
            .store(in: &cancellables)
    }
}
