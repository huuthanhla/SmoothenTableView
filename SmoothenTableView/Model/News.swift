//
//  News.swift
//  SmoothenTableView
//
//  Created by MINATO on 9/2/18.
//  Copyright © 2018 MINATO. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let news = try? newJSONDecoder().decode(News.self, from: jsonData)

import Foundation

struct News: Codable {
    let by: String?
    let descendants, id: Int?
    let kids: [Int]?
    let score, time: Int?
    let title, type, url: String?
}

