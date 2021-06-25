//
//  Guide.swift
//  GuidebookChallenge
//
//  Created by Mengyuan Tian on 2021/6/22.
//

import Foundation

struct Guide: Decodable {
    var url: String
    var startDate: String
    var endDate: String
    var name: String
    var icon: String
    var venue: Venue?
    var objType: String
    var loginRequired: Bool
}

struct ResultArray: Decodable {
    var guides: [Guide]
    var count: String

    enum CodingKeys: String, CodingKey {
        case guides = "data"
        case count = "total"
    }
}

struct Venue: Decodable {
    var city: String?
    var state: String?
}
