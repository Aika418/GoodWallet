//
//  Tag.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/02.
//

import Foundation
import SwiftData

@Model
final class Tag: Hashable, Equatable {
    var id: UUID 
    var name: String
    var colorName: String
    @Relationship(deleteRule: .nullify) var purchases: [Purchase]?
    
    init(
        id: UUID = UUID(),
        name: String = "",
        colorName: String = "",
        purchases: [Purchase]? = nil
    ){
        self.id = id
        self.name = name
        self.colorName = colorName
        self.purchases = purchases
    }
    
    // Hashable プロトコルの要求
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable プロトコルの要求
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
}
