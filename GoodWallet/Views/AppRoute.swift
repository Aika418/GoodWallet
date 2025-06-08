//
//  AppRoute.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/06.
//

import SwiftUI
//あらかじめ決めた複数の選択肢（ケース）をひとまとめに管理
enum AppRoute: Hashable { 
    //hashで画面を区別
    case inputStep1
    case inputStep2
    case inputStep3
    case celebration
    case tagGallery(allTagNames: [String], initialTagName: String)
    //allTagNames: [String] → タグのリストを渡す。
    //initialTagName: String → 選んで表示するタグ名を渡す。

}
