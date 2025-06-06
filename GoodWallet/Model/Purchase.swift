//
//  Purchase.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/02.
//

import Foundation
import SwiftData


@Model
final class Purchase {
    var id: UUID
    var name: String
    var date: Date
    var price: Int
    var rating: Int
    var memo: String?
    var reason: String?
    var feeling: String?
    @Relationship(deleteRule: .nullify) var tags: [Tag]
    var photoURLsData: Data?

    @Transient
    var photoURLs: [String] {
        get {
            guard let photoURLsData = photoURLsData else { return [] }
            let decoder = JSONDecoder()
            return (try? decoder.decode([String].self, from: photoURLsData)) ?? []
        }
        set {
            let encoder = JSONEncoder()
            photoURLsData = try? encoder.encode(newValue)
        }
    }

    init(
        id: UUID = UUID(),
        name: String = "",
        date: Date = Date.now,
        price: Int = 0,
        rating: Int = 0,
        memo: String? = nil,
        reason: String? = nil,
        feeling: String? = nil,
        tags: [Tag] = [],
        photoURLs: [String] = []
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.price = price
        self.rating = rating
        self.memo = memo
        self.reason = reason
        self.feeling = feeling
        self.tags = tags
        self.photoURLs = photoURLs
    }
}
