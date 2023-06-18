//
//  Model.swift
//  Assignment16
//
//  Created by macbook  on 17.06.23.
//

import Foundation

struct PostModel: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

struct CommentModel: Codable {
    var name: String
    var body: String
}
