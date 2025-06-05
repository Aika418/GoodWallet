//
//  InputStep2View.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/05.
//

import SwiftUI

// MARK: – Tag Model
struct EnrichTag: Identifiable, Hashable {
    let id: UUID = .init()
    let title: String
    /// 画像アセット名（ある場合はこちらを優先）
    let assetName: String?
    /// SF Symbols 名（アセットが無い場合のフォールバック）
    let systemImage: String?
    let color: Color
}

/// 固定タグリスト
let enrichTags: [EnrichTag] = [
    .init(title: "まなび",   assetName: "学び",              systemImage: "book",             color: Color("Manabi")),
    .init(title: "らくちん", assetName: "ハンモック",     systemImage: nil,                color: Color("Rakuchin")),
    .init(title: "ほっこり", assetName: "コーヒー",              systemImage: "cup.and.saucer",   color: Color("Hokkori")),
    .init(title: "わいわい", assetName: "ワイングラス",              systemImage: "party.popper",     color: Color("Waiwai")),
    .init(title: "すこやか", assetName: "健康",              systemImage: "heart",            color: Color("Sukoyaka")),
    .init(title: "わくわく", assetName: "虫眼鏡",              systemImage: "magnifyingglass",  color: Color("Wakuwaku")),
    .init(title: "きらり",   assetName: "リップ",         systemImage: "lipstick",         color: Color("Kirari")),
    .init(title: "ときめき", assetName: "ペンライト",              systemImage: "sparkler",         color: Color("Tokimeki")),
    .init(title: "おすそわけ", assetName: "お裾分け",           systemImage: "gift",             color: Color("Osusowake"))
]

// MARK: – View
struct InputStep2View: View {
    // 選択されたタグ最大3つ保持
    @State private var selected: Set<EnrichTag> = []
    
    /// 3 列・セル間 12pt でギュッと並べる
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        VStack(spacing: 24) {
            // タイトル
            VStack(spacing: 8) {
                Text("豊かさタグ")
                    .font(.largeTitle)
                    .bold()
                Text("3つまで選択してください。")
                    .font(.body)
            }
            .padding(.top, 40)

            // Tag Grid
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(enrichTags) { tag in
                    TagSquareView(tag: tag, isSelected: selected.contains(tag))
                        .onTapGesture {
                            toggle(tag)
                        }
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // 次へボタン
            NavigationLink(destination: InputStep3View()) {
                Text("次へ")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(
                        Capsule().fill(selected.isEmpty ? Color.gray.opacity(0.4) : Color.pink.opacity(0.9))
                    )
            }
            .disabled(selected.isEmpty)
            .padding(.bottom, 40)
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    /// タグ選択トグル – 最大3個
    private func toggle(_ tag: EnrichTag) {
        if selected.contains(tag) {
            selected.remove(tag)
        } else if selected.count < 3 {
            selected.insert(tag)
        }
    }
}

// MARK: – Tag Square
struct TagSquareView: View {
    let tag: EnrichTag
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            tagIcon
                .frame(width: 64, height: 64)   // 少し大きめ
            Text(tag.title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
        .frame(width: 112, height: 112)      // タイルを 112×112 に拡大
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(tag.color.opacity(isSelected ? 0.25 : 0.1))          // 内部を淡く
                .overlay(                                                  // 枠線を追加
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(tag.color, lineWidth: 3)
                )
        )
    }

    @ViewBuilder
    private var tagIcon: some View {
        if let asset = tag.assetName {
            Image(asset)
                .resizable()
                .scaledToFit()
        } else if let sys = tag.systemImage {
            Image(systemName: sys)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(.black)
        }
    }
}

#Preview {
    NavigationStack {
        InputStep2View()
    }
}
