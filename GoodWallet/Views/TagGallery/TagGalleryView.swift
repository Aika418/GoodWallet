//
//  TagGalleryView.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/07.
//

import SwiftUI
import SwiftData

struct TagGalleryView: View {
    // 表示する全てのタグ名のリスト
    let allTagNames: [String]
    // 現在表示しているタグ名 (スクロール位置と同期)
    @State private var currentTagName: String?
    // モーダルで表示する選択中の購入アイテム
    @State private var selectedPurchase: Purchase? = nil
    // 各タグに対応する購入リストを取得するためのクエリ（ここでは単一のクエリで全ての購入を取得し、表示時にフィルタリング）
    @Query private var allPurchases: [Purchase]
    //ビューを作る時に全タグと最初に表示するタグ名を受け取る
    init(allTagNames: [String], initialTagName: String) {
        self.allTagNames = allTagNames
        // 初期表示するタグ名を設定
        _currentTagName = State(initialValue: initialTagName)
    }
    
    var body: some View {
        VStack(spacing: 0) { // <- 一番外側のVStack
            Spacer().frame(height: 20)          // ← 新しく追加：上余白
            // 横スクロール可能なタグ名のリスト
            tagNamesScrollView
            // 投資比率の表示
            investmentRatioView
            // 各タグに対応する購入リストを縦スクロールで表示 商品一覧を表示
            PurchaseGalleryScrollView(
                allPurchases: allPurchases,
                currentTagName: currentTagName ?? allTagNames.first ?? "",
                onSelect: { purchase in selectedPurchase = purchase }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // <- VStack全体にframeを適用
        .background(Color("BackgroundColor").ignoresSafeArea()) // 背景色を適用
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedPurchase) { purchase in
            PurchaseDetailView(purchase: purchase)
        }//購入アイテムをタップしたときに詳細画面をモーダルで表示
    }
    
    // MARK: - Computed Properties for View Composition
    
    /// タグ名の横スクロールリストを生成する算出プロパティ
    private var tagNamesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(allTagNames, id: \.self) { tagName in
                    // 個々のタグバブル表示をヘルパービューに切り出し
                    //tag.seiftの==メソッド
                    TagBubbleView(tagName: tagName, isSelected: tagName == currentTagName) {
                        withAnimation { currentTagName = tagName }
                    }
                    .containerRelativeFrame(.horizontal, count: 3, spacing: 5) // 1画面に3つ程度表示されるようにサイズ調整
                }
            }
            .padding(.horizontal)
        }
    }
    
    /// 投資比率表示部分を生成する算出プロパティ
    private var investmentRatioView: some View {
        VStack(spacing: 4) {
            Text("投資比率")
                .font(.body)
            // 現在選択されているタグの投資比率を計算して表示
            Text(calculatedInvestmentRatio) // 計算結果を表示
                .font(.system(size: 80))
                .foregroundColor(currentTagColor) // 現在選択中のタグの色を適用
        }
        .padding(.vertical)
    }
    
    /// 購入ギャラリー部分を生成する算出プロパティ
    private var purchaseGalleryContentView: some View {
        PurchaseGalleryScrollView(
            allPurchases: allPurchases,
            currentTagName: currentTagName ?? allTagNames.first ?? "",
            onSelect: { purchase in
                selectedPurchase = purchase
            }
        )
        .frame(maxHeight: .infinity) // 購入ギャラリーが縦方向に広がるように
    }
}

// 特定のタグの購入アイテムを表示するビュー
struct PurchaseGalleryScrollView: View {
    let allPurchases: [Purchase]
    let currentTagName: String
    let onSelect: (Purchase) -> Void
    
    // 現在のタグに一致する購入のみをフィルタリング
    private var filteredPurchases: [Purchase] {
        let filtered = allPurchases.filter { purchase in
            //tag.seiftの==メソッド
            purchase.tags.contains(where: { $0.name == currentTagName })
        }
        
        // デバッグ出力：フィルタリングされた購入アイテムの画像パスを確認
        print("\n--- Debug: Filtered Purchases for Tag: \(currentTagName) ---")
        if filtered.isEmpty {
            print("No purchases found for this tag.")
        } else {
            for purchase in filtered {
                print("Purchase: \(purchase.name), photoURLs: \(purchase.photoURLs)")
            }
        }
        print("---------------------------------------------------\n")
        
        return filtered
    }

    var body: some View {
        // 2列の柔軟な幅のグリッド
        let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filteredPurchases) { purchase in
                    PurchaseGalleryItemView(purchase: purchase)
                        .onTapGesture { onSelect(purchase) }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

// 購入アイテム個別のビュー
struct PurchaseGalleryItemView: View {
    let purchase: Purchase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 画像の表示エリア
            Group { // 画像表示と「画像なし」プレースホルダーをGroupでまとめる
                if let firstPhotoURLString = purchase.photoURLs.first {
                    if let uiImage = UIImage(contentsOfFile: firstPhotoURLString) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                Text("画像なし")
                                    .foregroundColor(.gray)
                            )
                    }
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Text("画像なし")
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(width: 160, height: 160)   // <-- fixed square
            .cornerRadius(8)
            .clipped()
            
            // 日付
            Text(formatDate(purchase.date))
                .font(.caption)
                .foregroundColor(.gray)
            
            // 商品名
            Text(purchase.name)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            
            // 評価（星）
            HStack(spacing: 2) {
                ForEach(0..<5) { index in
                    Image(systemName: index < purchase.rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
        }
        // .frame(width: 160) // 削除: グリッドの柔軟な幅に任せる
        .padding(8) // アイテム内のパディング
        .background(Color.white) // アイテムの背景色
        .cornerRadius(12) // 角丸
        .shadow(radius: 4) // 影
    }
}

#Preview {
    // プレビュー用のダミーデータ
    let dummyTags = ["わくわく", "すこやか", "ほっこり", "きらり"]
    // ダミーのPurchaseデータをModelContainerに設定する必要あり
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Purchase.self, Tag.self, configurations: config)
    
    // ダミー購入データを作成し、タグを紐づける
    let tagWakwaku = Tag(name: "わくわく")
    let tagSukoyaka = Tag(name: "すこやか")
    let tagHokkori = Tag(name: "ほっこり")
    let tagKirari = Tag(name: "きらり")
    
    container.mainContext.insert(tagWakwaku)
    container.mainContext.insert(tagSukoyaka)
    container.mainContext.insert(tagHokkori)
    container.mainContext.insert(tagKirari)
    
    let purchase1 = Purchase(name: "おもちゃ", price: 3000, rating: 4, tags: [tagWakwaku, tagSukoyaka])
    let purchase2 = Purchase(name: "本", price: 1500, rating: 5, tags: [tagWakwaku, tagHokkori])
    let purchase3 = Purchase(name: "健康食品", price: 5000, rating: 3, tags: [tagSukoyaka])
    let purchase4 = Purchase(name: "プレゼント", price: 2000, rating: 5, tags: [tagKirari])
    
    container.mainContext.insert(purchase1)
    container.mainContext.insert(purchase2)
    container.mainContext.insert(purchase3)
    container.mainContext.insert(purchase4)
    
    return NavigationStack {
        // 初期表示タグ名を指定
        TagGalleryView(allTagNames: dummyTags, initialTagName: "わくわく")
            // ここでModelContainerを適用
            .modelContainer(container)
    }
}

// MARK: - Helper Views

/// 個々のタグバブルを表示するヘルパービュー
private struct TagBubbleView: View {
    let tagName: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(tagName)
            .font(.headline)                      // bigger font
            .padding(.horizontal, 16)             // wider
            .padding(.vertical, 8)                // taller
            .background(
                Capsule()
                    .fill(isSelected
                          ? Color.pink.opacity(0.4)
                          : Color.gray.opacity(0.15))
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.pink : Color.clear, lineWidth: 2)
            )
            .onTapGesture(perform: onTap)
    }
}

extension TagGalleryView {
    /// 現在選択されているタグの投資比率を計算する算出プロパティ
    /// (タグ出現回数に基づく計算)
    private var calculatedInvestmentRatio: String {
        // 現在選択されているタグ名を取得
        guard let tagName = currentTagName else { return "0%" }
        
        // tagOccurrencePercentages 算出プロパティから、選択中のタグの割合を見つける
        if let tagData = tagOccurrencePercentages.first(where: { $0.tagName == tagName }) {
            // 割合をパーセント文字列としてフォーマット（小数点以下なしに戻す）
            return String(format: "%.0f%%", tagData.percentage * 100)
        } else {
            // 選択中のタグが見つからない場合は0%を返す
            return "0%"
        }
    }
    
    /// 購入データから各タグの出現回数を集計し、割合を計算する算出プロパティ
    private var tagOccurrencePercentages: [(tagName: String, percentage: Double)] {
        // 購入が空の場合は空配列を返す
        guard !allPurchases.isEmpty else { return [] }
        
        // タグの出現回数をカウントする辞書
        var tagCounts: [String: Int] = [:]
        
        // 各購入のタグをカウント
        for purchase in allPurchases {
            for tag in purchase.tags {
                // タグの出現回数をインクリメント
                tagCounts[tag.name, default: 0] += 1
            }
        }
        
        // タグが1つも存在しない場合は空配列を返す
        guard !tagCounts.isEmpty else { return [] }
        
        // 全タグの出現回数の合計を計算
        let totalTagCount = tagCounts.values.reduce(0, +)
        
        // 各タグの割合を計算
        let percentages = tagCounts.map { (tagName, count) in
            (tagName: tagName, percentage: Double(count) / Double(totalTagCount))
        }
        
        // 割合の大きい順にソート (HomeViewに合わせるが、このビューの表示には直接影響しない)
        let sortedPercentages = percentages.sorted(by: { $0.percentage > $1.percentage })
        
        return sortedPercentages
    }
    
    /// 現在選択されているタグの色を返す算出プロパティ
    private var currentTagColor: Color {
        guard let tagName = currentTagName, let colorName = tagColorNameMapping[tagName] else {
            // タグが見つからない、またはマッピングに存在しない場合はデフォルトの色（オレンジ）を返す
            return .orange
        }
        // Asset Catalogから色を取得
        return Color(colorName)
    }
}

// MARK: - Date Formatting
extension View {
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
