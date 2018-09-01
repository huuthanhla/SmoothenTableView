//
//  Post.swift
//  SmoothenTableView
//
//  Created by MINATO on 9/1/18.
//  Copyright © 2018 MINATO. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let post = try? newJSONDecoder().decode(Post.self, from: jsonData)

import Foundation

typealias Post = [PostElement]

struct PostElement: Codable {
    let userID, id: Int?
    let title, body: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
