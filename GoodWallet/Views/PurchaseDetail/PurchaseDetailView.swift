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
    @State private var showThumbsUpAnimation = false
    @State private var animationTriggerID = UUID()
    @State private var showEncouragementMessage = false
    @State private var encouragementMessages = [
        "“微妙だった”も大事な経験だよ 🌱",
        "次はもっと良い選択ができるかも！✨",
        "それでも自分を責めなくていいよ 🍀",
        "その選択にも意味があったはず 🌈",
        "あなたはちゃんと考えて行動してるよ ☁️",
        "迷いも成長の一歩 🌱",
        "大丈夫、全部がうまくいくわけじゃないよ 😊",
        "今の気づきが、きっと未来を変えるよ 🔍",
        "こういう日もあるさ ☕️",
        "後悔より、次に活かせばOK！🛠️"
    ]
    @State private var selectedEncouragementMessage = ""
    
    var body: some View {
        ZStack {
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
                
                // 30日後の再評価ボタン
                if Calendar.current.dateComponents([.day], from: purchase.date, to: Date()).day ?? 0 >= 30 {
                    VStack(spacing: 12) {
                        Text("振り返ってどう思う？")
                            .font(.caption17)
                            .foregroundColor(.primary)

                        HStack(spacing: 40) {
                            Button(action: {
                                withAnimation {
                                    showThumbsUpAnimation = true
                                    animationTriggerID = UUID()
                                }
                                // 再評価ロジックをここに追加
                            }) {
                                Text("👍")
                                    .font(.largeTitle)
                                    .padding()
                                    .background(Color.green.opacity(0.2))
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(showThumbsUpAnimation ? Color.green : Color.clear, lineWidth: 3)
                                    )
                            }

                            Button(action: {
                                selectedEncouragementMessage = encouragementMessages.randomElement() ?? ""
                                withAnimation {
                                    showEncouragementMessage = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        showEncouragementMessage = false
                                    }
                                }
                                // 再評価ロジックをここに追加
                            }) {
                                Text("👎")
                                    .font(.largeTitle)
                                    .padding()
                                    .background(Color.red.opacity(0.2))
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(showEncouragementMessage ? Color.red : Color.clear, lineWidth: 3)
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.top, 20)
                }
                }
                .padding(.vertical)
                .background(Color("BackgroundColor"))   // Match outer background
                .cornerRadius(28)
                .padding()
            }
            }
            // Overlay thumbs up animation
            if showThumbsUpAnimation {
                ZStack {
                    ForEach(0..<20, id: \.self) { i in
                        let randomX = CGFloat.random(in: -220...220)
                        let delay = Double.random(in: 0...0.5)
                        let baseY = UIScreen.main.bounds.height

                        Image(systemName: "hand.thumbsup.fill")
                            .font(.largeTitle50)
                            .foregroundColor(Color.yellow)
                            .position(x: UIScreen.main.bounds.width / 2 + randomX,
                                      y: baseY)
                            .modifier(FloatingThumbsUpEffect(delay: delay, triggerID: animationTriggerID))
                    }
                }
            }
            // Overlay encouragement message
            if showEncouragementMessage {
                VStack {
                    Text(selectedEncouragementMessage)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(12)
                        .padding(.top, 80)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}

struct FloatingThumbsUpEffect: ViewModifier {
    var delay: Double
    var triggerID: UUID
    @State private var animate = false

    func body(content: Content) -> some View {
        content
            .offset(y: animate ? -UIScreen.main.bounds.height * 0.8 : 0)
            .opacity(animate ? 0 : 1)
            .scaleEffect(animate ? 1.4 : 0.8)
            .onAppear {
                animate = false
                withAnimation(Animation.easeOut(duration: 2).delay(delay)) {
                    animate = true
                }
            }
            .id(triggerID)
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
