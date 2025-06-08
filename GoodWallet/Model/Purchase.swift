//
//  Purchase.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/02.
//

import Foundation
import SwiftData

//SwiftDataのデータモデル一件の購入データ
@Model
final class Purchase {
    var id: UUID //一意識別ID
    var name: String
    var date: Date
    var price: Int
    var rating: Int
    var memo: String?
    var reason: String?
    var feeling: String?
    @Relationship(deleteRule: .nullify) var tags: [Tag]//関連するTagが削除されてもPurchase側はnull（空）になるだけで削除されない。
    var photoURLsData: Data?

    @Transient //一時的なJSONデータとして保存
    var photoURLs: [String] {
        get {
            //photoURLsDataがあればJSONDecoderでデコードして文字列配列にして返す
            guard let photoURLsData = photoURLsData else { return [] }
            let decoder = JSONDecoder()
            //DataをString型としてでこーど
            return (try? decoder.decode([String].self, from: photoURLsData)) ?? []
        }
        set {
            let encoder = JSONEncoder()
            photoURLsData = try? encoder.encode(newValue)
        }
    }

    //初期化
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
