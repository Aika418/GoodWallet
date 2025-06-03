//
//  Tag.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/02.
//

import Foundation
import SwiftData

@Model
final class Tag{
    var id: UUID 
    var name: String
    var colorHex: String
    
    
    init(
        id: UUID = UUID(),
        name: String = "",
        colorHex: String = ""
    ){
        self.id = id
        self.name = name
        self.colorHex = colorHex
    }
}
