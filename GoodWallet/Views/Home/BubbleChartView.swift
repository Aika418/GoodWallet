//
//  BubbleChartView.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/03.
//

import SwiftUI
import SwiftData

// EnrichTagのタイトルとAsset Catalogの色名のマッピング
// BubbleChartViewとSingleBubbleViewの両方から参照するためファイルスコープに移動
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

struct BubbleChartView: View {
    // HomeViewで集計済みのデータを受け取る
    let aggregatedTags: [(tagName: String, percentage: Double)]

    // Environment for color scheme (useful for hex to Color conversion if needed)
    // @Environment(\.colorScheme) var colorScheme // Likely not needed if using Asset Colors directly

    // Computed property to process purchases and calculate tag percentages
    // private var tagPercentages: [(tag: Tag, percentage: Double)] { ... } // 削除

    // Helper function to convert hex string to Color (assuming format #RRGGBB or #AARRGGBB)
    // This assumes ColorExtension.swift exists and is accessible, otherwise this logic needs to be in an extension here.
    // private func colorFromHex(_ hex: String) -> Color { ... } // 削除

    var body: some View {
        VStack {
            Text("バブルチャート")
                .font(.headline)

            // デバッグプリント: 集計されたタグの割合
            // print("tagPercentages (集計後): \(tagPercentages)") // 詳細な出力が必要な場合アンコメント

            // Use GeometryReader to get the available size for drawing
            GeometryReader { geometry in
                ZStack {
                    // Draw bubbles for each tag percentage
                    ForEach(Array(aggregatedTags.enumerated()), id: \.element.tagName) { index, data in // 集計済みのデータを使用し、tagNameをidに指定
                        // Calculate bubble size and position
                        let minSize: CGFloat = 50
                        let maxSize: CGFloat = min(geometry.size.width, geometry.size.height) * 0.9 // 最大サイズをさらに調整 (0.9)

                        // 割合に基づいてバブルサイズを計算。最小サイズを保証し、NaN対策も行う。
                        let clampedPercentage = max(0, min(1, data.percentage)) // 割合を0から1の間にクランプ
                        let calculatedSize = minSize + (maxSize - minSize) * CGFloat(clampedPercentage)
                        
                        // 計算結果がNaNでないことを確認し、不正な場合は最小サイズを使用
                        let bubbleSize = calculatedSize.isNaN ? minSize : calculatedSize

                        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        let radius: CGFloat = aggregatedTags.count == 1 ? 0 : min(geometry.size.width, geometry.size.height) * 0.3

                        let angle = 2 * .pi / CGFloat(aggregatedTags.count) * CGFloat(index)
                        let positionX = center.x + radius * cos(angle)
                        let positionY = center.y + radius * sin(angle)

                        SingleBubbleView(
                            tagName: data.tagName,
                            percentage: data.percentage,
                            bubbleSize: bubbleSize,
                            position: CGPoint(x: positionX, y: positionY)
                        )
                    }
                }
            }
            .frame(height: 300) // Give the chart a fixed height
        }
    }
}

#Preview {
    // Create dummy data for preview
    let dummyAggregatedTags: [(tagName: String, percentage: Double)] = [
        // ダミーデータ例
        (tagName: "わくわく", percentage: 3.0/7.0),
        (tagName: "すこやか", percentage: 2.0/7.0),
        (tagName: "ほっこり", percentage: 1.0/7.0),
        (tagName: "きらり", percentage: 1.0/7.0)
    ].sorted(by: { $0.percentage > $1.percentage })
    
    return NavigationStack {
        // Pass dummy data to the preview
        // プレビュー用にダミーの集計済みデータを作成して渡す
        BubbleChartView(aggregatedTags: dummyAggregatedTags)
    }
    // PreviewではModelContainerは不要（データを直接渡すため）
}

// MARK: - Single Bubble View
/// 個々のバブルを描画するヘルパービュー
private struct SingleBubbleView: View {
    let tagName: String
    let percentage: Double
    let bubbleSize: CGFloat
    let position: CGPoint

    var body: some View {
        VStack {
            Text(tagName) // タグ名を表示
                .font(.caption) // Adjust font size
                .bold()
                .foregroundColor(.black) // Text color inside bubble
        }
        .frame(width: bubbleSize, height: bubbleSize) // Size the text container same as bubble
        .background(
            Circle()
                .fill(Color(tagColorNameMapping[tagName] ?? "Gray").opacity(0.7)) // タグ名から色を取得
        )
        .clipShape(Circle()) // Ensure text container is clipped to circle
        .position(position) // Position the bubble
        // Ensure bubbles stay within bounds (optional, might need adjustments)
        // .offset(x: min(max(-positionX + bubbleSize/2, 0), geometry.size.width - positionX - bubbleSize/2),
        //         y: min(max(-positionY + bubbleSize/2, 0), geometry.size.height - positionY - bubbleSize/2))
        // Simple layering by drawing order (larger first or smaller first might look better depending on opacity)
        // Current sort is largest percentage first.
    }
}
