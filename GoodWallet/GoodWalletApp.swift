//
//  GoodWalletApp.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/02.
//

import SwiftUI
import SwiftData

@main //アプリ起動時に最初に実行
struct GoodWalletApp: App {
    var body: some Scene { //アプリのUIウィンドウの定義
        WindowGroup { //メインウィンドウを定義
            HomeView()
        }
        .modelContainer(for: Purchase.self)//swiftdata保存のための箱を作る
    }
}
