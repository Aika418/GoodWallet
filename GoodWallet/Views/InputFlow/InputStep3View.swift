//
//  InputStep3View.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/05.
//

import SwiftUI

struct InputStep3View: View {

    // MARK: - State
    @State private var reason: String  = ""
    @State private var feeling: String = ""
    @State private var isShowingCelebration = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.navigationPath) private var navPath

    // MARK: - Body
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 32) {

                // ───────── 購入理由 ─────────
                VStack(alignment: .leading, spacing: 8) {
                    Text("どうして購入しましたか？")
                        .font(.body)
                    memoEditor(text: $reason)
                }

                // ───────── 気持ち ─────────
                VStack(alignment: .leading, spacing: 8) {
                    Text("今どんな気持ちですか？")
                        .font(.body)
                    memoEditor(text: $feeling)
                }

                // ───────── 投資ボタン ─────────
                Button {
                    // データ保存を行う処理をここに追加
                    isShowingCelebration = true
                } label: {
                    Text("投資")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: 140)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color.customAccentColor.opacity(0.8))
                        )
                        .shadow(color: .black.opacity(0.15),
                                radius: 6, x: 0, y: 3)
                        .padding(.top, 50)          // 入力欄との間に余白（狭め）
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 60)   // 下余白を広げてボタンを上へ
            }
            .padding(.horizontal, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingCelebration) {
            CelebrationView(onFinish: {
                navPath?.wrappedValue = NavigationPath()
            })
        }
    }

    // メモ入力用 TextEditor (共通)
    @ViewBuilder
    private func memoEditor(text: Binding<String>) -> some View {
        TextEditor(text: text)
            .frame(height: 110)
            .padding(8)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.customLineColor, lineWidth: 1)
            )
    }
}

#Preview {
    NavigationStack {
        InputStep3View()
            .environment(\.navigationPath, .constant(NavigationPath()))
    }
}
