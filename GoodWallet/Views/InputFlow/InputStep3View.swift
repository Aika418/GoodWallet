//
//  InputStep3View.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/05.
//

import SwiftUI
import SwiftData

struct InputStep3View: View {

    // お祝い画面を表示するかどうか
    @State private var isShowingCelebration = false
    //画面を閉じるための機能を環境変数
    @Environment(\.dismiss) private var dismiss
    @Environment(\.navigationPath) private var navPath
    //データベースへの保存や読み込みを行う
    @Environment(\.modelContext) private var modelContext
    //前の画面から購入情報を受け取る
    @Bindable var purchase: Purchase
    //前の画面で選ばれたタグのリスト
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
                        .font(.body20)
                    memoEditor(text: $purchase.reason)
                        .font(.body20)
                }

                // ───────── 気持ち ─────────
                VStack(alignment: .leading, spacing: 8) {
                    Text("今どんな気持ちですか？")
                        .font(.body20)
                    memoEditor(text: $purchase.feeling)
                        .font(.body20)
                }

                // ───────── 投資ボタン ─────────
                HStack {
                    Spacer()
                    Button {
                        // データ保存を行う処理をここに追加

                        // EnrichTagをTagモデルに変換してpurchase.tagsに設定
                        var purchaseTags: [Tag] = []
                        //選ばれたタグを順番に処理
                        for enrichTag in selectedEnrichTags {
                            let tagName = enrichTag.title
                            let tagColorName = tagColorNameMapping[tagName] ?? "Gray"
                            
                            // 同じ名前のTagが既に存在するかをクエリで確認
                            //tag.seiftの==メソッド
                            var descriptor = FetchDescriptor<Tag>(predicate: #Predicate { $0.name == tagName })
                            descriptor.fetchLimit = 1 // 1つ見つかれば十分
                            //firstで一つだとってくる
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
                            .font(.title30)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)      // 十分な横幅を確保
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(Color.customAccentColor.opacity(0.8))
                            )
                            .shadow(color: .black.opacity(0.15),
                                    radius: 6, x: 0, y: 3)
                            .padding(.top, 50)          // 入力欄との間に余白（狭め）
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 60)   // 下余白を広げてボタンを上へ
            }
            .padding(.horizontal, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButton()
            }
        }
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
            .frame(minHeight: 90, maxHeight: UIScreen.main.bounds.height * 0.18)
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
