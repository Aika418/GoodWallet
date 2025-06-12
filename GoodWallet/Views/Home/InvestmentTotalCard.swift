//
//  InvestmentTotalCard.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/03.
//

import SwiftUI
import SwiftData

struct InvestmentTotalCard: View {
    //SwiftDataを使って、データベースのPurchaseを全部（または指定条件で）取得する変数
    //ここでは[Purchase]型の配列として使う
    @Query private var purchases: [Purchase]
    
    // purchasesの合計金額を計算
    //reduce: 配列をまとめて一つの値にする処理 最初に0（合計の初期値）からスタート
    private var totalAmount: Int {
        //$0は「これまでの合計金額」
        //$1は「現在処理中のPurchase要素」
        //$1.priceはそのPurchaseが持っている金額（整数）
        purchases.reduce(0) { $0 + $1.price }
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.customLineColor, lineWidth: 2)//カードの枠線
            .aspectRatio(1.7, contentMode: .fit) //カードの高さ
            .padding(.horizontal, 40)//左右に余白
            .overlay(//カードの上に重ねる
                //全てのテキストが左側を基準
                //縦の余白を16ポイント
                VStack(alignment: .leading, spacing: 16) {
                    Text("あなたは自分に")
                        .font(.body20)
                        .foregroundColor(.black)
                        .padding(.leading, 0)
                    Text("¥\(totalAmount)")
                        .font(.largeTitle50)
                        .foregroundColor(Color.customNumColor)
                        .padding(.leading, 32)
                    Text("投資しました。")
                        .font(.body20)
                        .foregroundColor(.black)
                        .padding(.leading, 150)
                }
            )
    }
}

#Preview {
    InvestmentTotalCard()
        .modelContainer(for: Purchase.self)
    //Purchaseデータを保存する場所（データベース）を準備
}
