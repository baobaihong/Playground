//
//  PhotoModel.swift
//  Playground
//
//  Created by Jason on 2024/2/20.
//

import Foundation

/*
 JSON sample data
 "albumId": 1,
 "id": 1,
 "title": "accusamus beatae ad facilis cum similique qui sunt",
 "url": "https://via.placeholder.com/600/92c952",
 "thumbnailUrl": "https://via.placeholder.com/150/92c952"
 */
struct PhotoModel: Identifiable, Codable {
    let albumId, id: Int
    let title: String
    let url, thumbnailUrl: String
}
