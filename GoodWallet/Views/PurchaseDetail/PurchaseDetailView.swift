//
//  PurchaseDetailView.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/07.
//

import SwiftUI

struct PurchaseDetailView: View {
    let purchase: Purchase
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Full-screen background color
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                // 閉じるボタン
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal)
                
                // 日付
                Text(formatDate(purchase.date))
                    .font(.title30)
                    .padding(.top, 8)
                
                // 星
                HStack(spacing: 2) {
                    ForEach(0..<5) { idx in
                        Image(systemName: idx < purchase.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.title2)
                    }
                }
                
                // 画像
                Group {
                    if let firstPhotoURLString = purchase.photoURLs.first,
                       let uiImage = UIImage(contentsOfFile: firstPhotoURLString) {
                        GeometryReader { geometry in
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipped()
                                .cornerRadius(16)
                        }
                        .aspectRatio(1, contentMode: .fit)
                    } else {
                        GeometryReader { geometry in
                            Image("花")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipped()
                                .cornerRadius(16)
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding(.top, 4)
                
                // 商品名
                Text(purchase.name)
                    .font(.title25)
                    .padding(.top, 4)
                
                // 値段
                Text("¥\(purchase.price)")
                    .font(.title30)
                    .foregroundColor(Color.customNumColor)
                    .padding(.bottom,10)
                
                // タグ (拡大表示)
                HStack(spacing: 12) {
                    ForEach(purchase.tags, id: \.id) { tag in
                        Text(tag.name)
                            .font(.caption15)                               // 大きめのフォント
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)                      // 幅広めのパディング
                            .padding(.vertical, 8)                         // 高さ広めのパディング
                            .background(
                                Capsule()
                                    .fill(Color(tagColorNameMapping[tag.name] ?? "Gray")
                                    .opacity(0.2))
                            )
                    }
                }
                
                // 購入理由
                VStack(alignment: .leading, spacing: 4) {
                    Text("購入に至った理由")
                        .font(.caption15)
                        .bold()
                        .padding(.top,15)
                    Text(purchase.reason ?? "")
                        .font(.caption15)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // 気持ち
                VStack(alignment: .leading, spacing: 4) {
                    Text("気持ち")
                        .font(.caption15)
                        .bold()
                    Text(purchase.feeling ?? "")
                        .font(.caption15)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color("BackgroundColor"))   // Match outer background
                .cornerRadius(28)
                .padding()
            }
        }
    }
}

#Preview {
    // プレビュー用ダミーデータ
    let tag1 = Tag(name: "ほっこり")
    let tag2 = Tag(name: "すこやか")
    let tag3 = Tag(name: "らくちん")
    let purchase = Purchase(
        name: "まくら",
        date: Date(timeIntervalSince1970: 1748121600),
        price: 3000,
        rating: 5,
        memo: nil,
        reason: "最近、よく眠れない日が続いていたので、心地よい睡眠を手に入れるために購入",
        feeling: "どのくらい睡眠の質が変わるのか今からとても楽しみ。",
        tags: [tag1, tag2, tag3],
        photoURLs: []
    )
    PurchaseDetailView(purchase: purchase)
}
