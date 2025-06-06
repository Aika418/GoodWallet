//
//  NavigationPathKey.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/06.
//

import SwiftUI

private struct NavigationPathKey: EnvironmentKey {
    static var defaultValue: Binding<NavigationPath>? = nil
}

extension EnvironmentValues {
    /// NavigationStack の path を子ビューにバインディングで渡すためのキー
    var navigationPath: Binding<NavigationPath>? {
        get { self[NavigationPathKey.self] }
        set { self[NavigationPathKey.self] = newValue }
    }
}
