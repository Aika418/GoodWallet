//
//  AppRoute.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/06.
//

import SwiftUI

enum AppRoute: Hashable {
    case inputStep1
    case inputStep2
    case inputStep3
    case celebration
    case tagGallery(allTagNames: [String], initialTagName: String)
}
