//
//  NavigationPathKey.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/06.
//

import SwiftUI
//画面遷移の履歴を共有
//keyで特別な鍵を作る
private struct NavigationPathKey: EnvironmentKey {
    //鍵の初期値
    static var defaultValue: Binding<NavigationPath>? = nil
}

extension EnvironmentValues {
    //NavigationStack（画面の履歴管理）を子画面（子ビュー）でも使えるようにしたい
    var navigationPath: Binding<NavigationPath>? {
        //SwiftUIのEnvironmentValuesに対して、
        //自分で作った特別な鍵（NavigationPathKey）を使って値を読み書きする仕組み
        //navigationPathというデータを読み出すときの処理
        get { self[NavigationPathKey.self] }
        //navigationPathというデータに新しい値をセット
        set { self[NavigationPathKey.self] = newValue }
    }
}
