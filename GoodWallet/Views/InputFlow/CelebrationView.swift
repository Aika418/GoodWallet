//
//  CelebrationView.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/06.
//

import SwiftUI

struct CelebrationView: View {

    // dismiss で NavigationStack のルート (HomeView) へ戻る
    @Environment(\.dismiss) private var dismiss
    // NavigationStack の path を取得（HomeView へ戻るため）
    
    // 完了時に呼ばれるクロージャ
    var onFinish: () -> Void

    // カスタムカラー
    private let accent    = Color.customAccentColor      // ピンク
    private let bgColor   = Color("BackgroundColor")     // 背景

    /// 表示候補メッセージ
    private static let messages: [String] = [
        "自分を労る\n大事な\n一歩！",
        "いい買い物で\n心が豊かに！",
        "今日の投資に\n拍手！",
        "あなたの選択が\n未来を照らす！",
        "ワクワクを\n手に入れたね！",
        "最高の\n自己投資！",
        "未来の自分が\n喜んでる！",
        "その一歩が\n輝きを生む！",
        "素敵な選択に\n乾杯！",
        "今日も\n自分アップデート！"
    ]
    
    @State private var message: String

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
        _message = State(initialValue: Self.messages.randomElement() ?? "")
    }

    var body: some View {
        ZStack {
            // 全面背景
            bgColor.ignoresSafeArea()

            VStack(spacing: 16) {

                // ────────── 閉じる (×) ボタン ──────────
                HStack {
                    Button {
                        // 完了クロージャを実行
                        onFinish()
                        // そのあと自分自身を閉じる
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 28, weight: .regular))
                            .foregroundColor(.gray)
                            .padding()
                    }
                    Spacer()
                }

                Spacer()

                // ────────── メッセージカード ──────────
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color.white)
                    .frame(maxWidth: 300, maxHeight: 340)
                    .overlay(
                        Text(message)
                            .font(.system(size: 40, weight: .heavy))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(accent)
                            .shadow(color: accent.opacity(0.35), radius: 4, x: 2, y: 2)
                    )
                    .offset(y: -40)                                  // up
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 5)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            VStack {
                HStack {
                    Spacer()
                    Image("右上")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)               // さらに大きく
                        .offset(x: -24, y: 24)                        // 内側へ少しオフセット
                }
                Spacer()
                HStack {
                    Image("左下")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)               // さらに大きく
                        .offset(x: 24, y: -24)                        // 内側へ少しオフセット
                    Spacer()
                }
            }
            .padding(32)
        }
        .navigationBarBackButtonHidden(true) // ← ナビバーの戻るを隠す
    }
}

#Preview {
    NavigationStack {
        // プレビュー用に空のクロージャを渡す
        CelebrationView(onFinish: {})
    }
}
