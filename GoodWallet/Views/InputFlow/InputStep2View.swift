//
//  InputStep2View.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/05.
//

import SwiftUI
import SwiftData

// タグを表す構造体
struct EnrichTag: Identifiable, Hashable {
    let id: UUID = .init()
    let title: String
    /// 画像アセット名（ある場合はこちらを優先）
    let assetName: String?
    /// アセットが無い場合
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

// 画面
struct InputStep2View: View {
    // 選択されたタグ最大3つ保持
    @State private var selected: Set<EnrichTag> = []
    
    /// 3 列・セル幅は 112〜140pt で自動調整（画面に余裕があると少し広がる）
    private let columns = Array(repeating: GridItem(.flexible(minimum: 112, maximum: 140), spacing: 12), count: 3)
//前の画面から受け取ったデータをここで使う
    @Bindable var purchase: Purchase

    var body: some View {
        VStack(spacing: 24) {
            // タイトル
            VStack(spacing: 8) {
                Text("豊かさタグ")
                    .font(.title30)
                Text("3つまで選択してください。")
                    .font(.body20)
            }
            .padding(.top, 40)

            //3列のタググリッド
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
            NavigationLink(destination: InputStep3View(purchase: purchase, selectedEnrichTags: selected)) {
                Text("次へ")
                    .font(.title25)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        Capsule().fill(selected.isEmpty ? Color.gray.opacity(0.4) : Color.customAccentColor.opacity(0.8))
                    )
            }
            .disabled(selected.isEmpty)
            .padding(.bottom, 40)
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButton()
            }
        }
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
    //表示するタグのデータ
    let tag: EnrichTag
    //選択状態
    let isSelected: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 6) {
                tagIcon
                    .aspectRatio(1, contentMode: .fit)
                    .padding(12)
                Text(tag.title)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer(minLength: 0)
            }
            .frame(width: geometry.size.width, height: geometry.size.width) // 幅=高さ
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(tag.color.opacity(isSelected ? 0.25 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(tag.color, lineWidth: 3)
                    )
            )
        }
        .aspectRatio(1, contentMode: .fit) // 親グリッドの幅に合わせて正方形
    }

    
    @ViewBuilder
    private var tagIcon: some View {
        //画像の表示
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
        InputStep2View(purchase: Purchase())
    }
}
