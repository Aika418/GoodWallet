//
//  HomeView.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/03.
//
import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var navPath = NavigationPath()
    @Query var purchases: [Purchase]
    @State private var displayedAggregatedTags: [(tagName: String, percentage: Double)] = [] // バブルチャートに表示する集計データ
    @State private var aggregationTimer: Timer? // 遅延更新用タイマー

    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack(alignment: .topTrailing) {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    Spacer().frame(height: 50)
                    
                    // バブルチャートに渡すデータを事前に集計
                    BubbleChartView(aggregatedTags: displayedAggregatedTags)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                    InvestmentTotalCard()
                        .padding(.bottom, 50)
                }

                // FloatingButtonを右上に配置
                FloatingButton(action: {
                    navPath.append(AppRoute.inputStep1)
                })
                .padding(.bottom, 750)
                .padding(.trailing, 20)
            }
            // ルート enum に応じた遷移先
            .navigationDestination(for: AppRoute.self) { route in
                if case .inputStep1 = route {
                    let purchase = Purchase()
                    InputStep1View(purchase: purchase)
                } else {
                    EmptyView()
                }
            }
        } // end NavigationStack
        .environment(\.navigationPath, $navPath)
        // purchases の変更を監視し、集計データを遅延更新
        .onChange(of: purchases) { oldPurchases, newPurchases in
            // タイマーをキャンセルして新しい更新を待つ
            aggregationTimer?.invalidate()
            
            // 少し遅延させてから集計と表示データの更新を行う
            // この遅延により、@Queryの更新が落ち着く時間を設ける
            aggregationTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                let latestAggregatedTags = aggregateTags(from: newPurchases)
                self.displayedAggregatedTags = latestAggregatedTags
            }
        }
        .onAppear { // Viewが表示されたときに初期集計を行う
            let initialAggregatedTags = aggregateTags(from: purchases)
            self.displayedAggregatedTags = initialAggregatedTags
        }
    }
    
    // 購入データからタグを集計する関数
    private func aggregateTags(from purchases: [Purchase]) -> [(tagName: String, percentage: Double)] {
        // 購入が空の場合は空配列を返す
        guard !purchases.isEmpty else { return [] }
        
        // タグの出現回数をカウントする辞書
        var tagCounts: [String: Int] = [:]
        
        // 各購入のタグをカウント
        for purchase in purchases {
            // デバッグ出力：各購入のタグ情報
            print("購入: \(purchase.name), タグ数: \(purchase.tags.count)")
            for tag in purchase.tags {
                print("  - タグ: \(tag.name), ID: \(tag.id)")
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
        
        // 割合の大きい順にソート
        let sortedPercentages = percentages.sorted(by: { $0.percentage > $1.percentage })
        
        // デバッグ出力
        print("\n=== タグ集計結果 ===")
        print("総タグ数: \(totalTagCount)")
        print("購入数: \(purchases.count)")
        for item in sortedPercentages {
            print("タグ: \(item.tagName), 出現回数: \(tagCounts[item.tagName] ?? 0), 割合: \(String(format: "%.2f", item.percentage * 100))%")
        }
        print("==================\n")
        
        return sortedPercentages
    }
}

#Preview {
    HomeView()
}
