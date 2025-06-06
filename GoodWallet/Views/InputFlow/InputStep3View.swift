//
//  InputStep3View.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/05.
//

import SwiftUI
import SwiftData

struct InputStep3View: View {

    // MARK: - State
    @State private var isShowingCelebration = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.navigationPath) private var navPath
    @Environment(\.modelContext) private var modelContext

    @Bindable var purchase: Purchase
    let selectedEnrichTags: Set<EnrichTag>

    // EnrichTagのタイトルとAsset Catalogの色名のマッピング
    private let tagColorNameMapping: [String: String] = [
        "まなび": "Manabi",
        "らくちん": "Rakuchin",
        "ほっこり": "Hokkori",
        "わいわい": "Waiwai",
        "すこやか": "Sukoyaka",
        "わくわく": "Wakuwaku",
        "きらり": "Kirari",
        "ときめき": "Tokimeki",
        "おすそわけ": "Osusowake"
    ]

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
                    memoEditor(text: $purchase.reason)
                }

                // ───────── 気持ち ─────────
                VStack(alignment: .leading, spacing: 8) {
                    Text("今どんな気持ちですか？")
                        .font(.body)
                    memoEditor(text: $purchase.feeling)
                }

                // ───────── 投資ボタン ─────────
                Button {
                    // データ保存を行う処理をここに追加

                    // EnrichTagをTagモデルに変換してpurchase.tagsに設定
                    var purchaseTags: [Tag] = []
                    for enrichTag in selectedEnrichTags {
                        let tagName = enrichTag.title
                        let tagColorName = tagColorNameMapping[tagName] ?? "Gray"
                        
                        // 同じ名前のTagが既に存在するかをクエリで確認
                        var descriptor = FetchDescriptor<Tag>(predicate: #Predicate { $0.name == tagName })
                        descriptor.fetchLimit = 1 // 1つ見つかれば十分
                        
                        if let existingTag = try? modelContext.fetch(descriptor).first {
                            // 既存のTagがあればそれを使用
                            purchaseTags.append(existingTag)
                        } else {
                            // 存在しない場合は新しいTagを作成して挿入
                            let newTag = Tag(name: tagName, colorName: tagColorName)
                            modelContext.insert(newTag)
                            purchaseTags.append(newTag)
                        }
                    }
                    purchase.tags = purchaseTags

                    // デバッグプリント: 保存直前のpurchase.tagsの内容を確認
                    print("保存直前のpurchase.tags:")
                    for tag in purchase.tags {
                        print("  名前: \(tag.name), ID: \(tag.id)")
                    }

                    // PurchaseオブジェクトをModelContextに挿入（保存）
                    modelContext.insert(purchase)

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
    private func memoEditor(text: Binding<String?>) -> some View {
        // Binding<String?> を Binding<String> に変換（nilの場合は""を使用）
        let nonOptionalText = Binding<String>(
            get: { text.wrappedValue ?? "" },
            set: { text.wrappedValue = $0.isEmpty ? nil : $0 } // 空文字の場合はnilに戻す
        )

        TextEditor(text: nonOptionalText)
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
        InputStep3View(purchase: Purchase(), selectedEnrichTags: [])
            .environment(\.navigationPath, .constant(NavigationPath()))
            .modelContainer(for: Purchase.self)
    }
}
