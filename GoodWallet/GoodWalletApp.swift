//
//  GoodWalletApp.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/02.
//

import SwiftUI
import SwiftData

@main
struct GoodWalletApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Purchase.self)
    }
}
