//
//  BubbleChartView.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/03.
//

import SwiftUI
import SwiftData

struct BubbleChartView: View {
    //  HomeViewから送られてきたタグデータ（名前と割合）を受け取るための変数
    let aggregatedTags: [(tagName: String, percentage: Double)]
    
    // バブルがタップされたときに実行されるアクション
    //引数としてタップされたタグ名（String）を渡す仕組み
    let onTapBubble: (String) -> Void

    //見た目
    var body: some View {
        VStack {
            // 画面の大きさを取得
            GeometryReader { geometry in
                //バブルを重ねる
                ZStack {
                    //タグデータを順番に取り出して、1個ずつバブルを描画
                    //enumerated() を使うことで index（番号）も一緒に取り出す
                    //ArrayでForEachが使えるように一度配列に変換
                    //.element→enumerated（）で取り出したデータの「要素部分」（番号ではなくデータ本体）
                    //    .tagName → その中のタグ名を識別子に指定しています。
                    //タグ名が同じものは一意に扱うようにしてね！**という指示になります。
                    ForEach(Array(aggregatedTags.enumerated()), id: \.element.tagName) { index, data in //index → データの順番（0,1,2…）data → タグ名と割合のデータそのもの
                        // バブルのサイズ
                        let minSize: CGFloat = 50
                        let maxSize: CGFloat = min(geometry.size.width, geometry.size.height) * 0.9 // 最大サイズをさらに調整 (0.9)

                        // データの割合が0〜1の範囲を超えないように制限
                        let clampedPercentage = max(0, min(1, data.percentage))
                        //  最小サイズから最大サイズまでの範囲で、バブルの大きさを決める
                        let calculatedSize = minSize + (maxSize - minSize) * CGFloat(clampedPercentage)
                        
                        // サイズがNaN（計算できない数値）になった場合は、最小サイズ
                        let bubbleSize = calculatedSize.isNaN ? minSize : calculatedSize
                        //バブルの中心位置を画面の中央に設定
                        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        //バブルを並べる円の半径 バブルが一個なら半径0
                        let radius: CGFloat = aggregatedTags.count == 1 ? 0 : min(geometry.size.width, geometry.size.height) * 0.3
                        //各バブルを円形に並べるための角度を計算
                        let angle = 2 * .pi / CGFloat(aggregatedTags.count) * CGFloat(index)
                        // 角度と半径を使ってX座標・Y座標を計算
                        let positionX = center.x + radius * cos(angle)
                        let positionY = center.y + radius * sin(angle)

                        //引数を渡して描画
                        SingleBubbleView(
                            tagName: data.tagName,
                            percentage: data.percentage,
                            bubbleSize: bubbleSize,
                            position: CGPoint(x: positionX, y: positionY),
                            onTap: onTapBubble // アクションをSingleBubbleViewに渡す
                        )
                    }
                }
            }
            .aspectRatio(0.75, contentMode: .fit) // 画面幅に応じた正方形サイズ
        }
    }
}

#Preview {
    // プレビュー用データ
    let dummyAggregatedTags: [(tagName: String, percentage: Double)] = [
        (tagName: "わくわく", percentage: 3.0/7.0),
        (tagName: "すこやか", percentage: 2.0/7.0),
        (tagName: "ほっこり", percentage: 1.0/7.0),
        (tagName: "きらり", percentage: 1.0/7.0)
    ].sorted(by: { $0.percentage > $1.percentage })
    
    return NavigationStack {
        BubbleChartView(aggregatedTags: dummyAggregatedTags, onTapBubble: { _ in })
    }
}

// MARK: - Single Bubble View
/// 個々のバブルを描画するヘルパービュー
private struct SingleBubbleView: View {
    //外から渡される情報（プロパティ）を定義
    let tagName: String
    let percentage: Double
    let bubbleSize: CGFloat
    let position: CGPoint
    
    // 親ビュー（BubbleChartView）にタップしたタグ名を伝える
    let onTap: (String) -> Void

    var body: some View {
        VStack {
            Text(tagName) // タグ名を表示
                .font(.caption15)
                .bold()
                .foregroundColor(.black)
        }
        .frame(width: bubbleSize, height: bubbleSize)//バブルの大きさを設定
        .background(//円の背景を塗る
            Circle()
                .fill(Color(tagColorNameMapping[tagName] ?? "Gray").opacity(0.7)) 
        )
        .clipShape(Circle()) // テキストなどが円形の背景の外にはみ出さないように
        .position(position) // 画面上のどの位置に置くかを決める
        .onTapGesture { // タップジェスチャーを追加
            onTap(tagName) // 親ビューにタグ名を返す
        }
    }
}
