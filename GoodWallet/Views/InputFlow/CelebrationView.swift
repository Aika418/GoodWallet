//
//  CelebrationView.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/06.
//

import SwiftUI

struct CelebrationView: View {

    // dismiss で NavigationStack のルート (HomeView) へ戻る
    @Environment(\.dismiss) private var dismiss
    // NavigationStack の path を取得（HomeView へ戻るため）
    
    // 完了時に呼ばれるクロージャ
    var onFinish: () -> Void

    // カスタムカラー
    private let accent    = Color.customAccentColor      // ピンク
    private let bgColor   = Color("BackgroundColor")     // 背景

    /// 表示候補メッセージ
    private static let messages: [String] = [
        "自分を労る\n大事な\n一歩！",
        "いい買い物で\n心が豊かに！",
        "今日の投資に\n拍手！",
        "あなたの選択が\n未来を\n照らす！",
        "ワクワクを\n手に入れたね！",
        "最高の\n自己投資！",
        "未来の自分が\n喜んでる！",
        "その一歩が\n輝きを生む！",
        "素敵な選択に\n乾杯！",
        "今日も自分\nアップデート！",
        "自分に\n「よくやった！」\nを贈ろう",
        "今日の\nあなたは\n無敵！",
        "一歩ずつ\nしっかり\n前進中！",
        "あなたの笑顔\n最高です！",
        "今日も\nあなたが\n主役！",
        "自分を\n信じて\n進もう！",
        "今日は\nちょっと\n特別な日！",
        "小さな勇気\n大きな前進！",
        "あなたの\n努力に拍手",
        "最高の\n自分に\n乾杯！",
        "「できた！」に\n気づく瞬間を\n大切に",
        "あなたの選択\nグッジョブ！",
        "自分へ\nご褒美の\n一言を",
        "今日の\nあなたは\nスーパースター",
        "自分へ\n「ナイス判断！」",
        "あなたの\n一歩が輝く",
        "ときどき\n空を見上げて\nみよう",
        "自分を\n甘やかす\n時間も\n大切",
        "今日は\n“あなたの日”\nにしよう",
        "自分を\n抱きしめる\n気持ちで",
        "ゆっくり\n深呼吸\n心ほぐして",
        "自分に\n「ありがとう」を",
        "自分を最強に\nメンタルケア",
        "頑張ってる\n自分を褒めて",
        "自分の\nペースで\n描く未来",
        "あなたの時間\n大切に",
        "ちょっと休憩\n気分転換！",
        "ストレス発散\n笑い飛ばせ！",
        "自分を\n甘やかすのも\nあり！",
        "可能性は\nあなたの中に",
        "その笑顔で\n世界を明るく",
        "自分の色で\n描く人生を",
        "ステップアップ\nは日々の\n積み重ね",
        "あなたの\n心は今日も\nキラキラ",
        "自分にいい波\nきてます！",
        "今日の\nあなたに\n三ツ星！",
        "頑張り\nすぎない\n自分もいいね",
        "あなたらしさ\n大切にね",
        "自分のペース\n大事に",
        "あなたの\n頑張り\nちゃんと\n見えてる",
        "今日という\n日に\nありがとう",
        "自分を\nもっと好きに\nなる",
        "あなたは\nもっと\n輝ける",
        "自分時間を\n大切に\nしよう",
        "成長は\n小さくても\nOK！",
        "自分への\n労いを\nしよう",
        "いつも\nあなたは\n完璧じゃ\nなくていい",
        "気づけば\n昨日より\n一歩前",
        "自分に\n「自由」を\nプレゼント",
        "頑張り屋さん\nのあなたへ",
        "あなたのペース\nあなたらしい",
        "自分を\n甘やかす\nチャンス！",
        "ひと息ついて\nまた進もう",
        "あなたの頑張り\n輝いてるよ",
        "自分に\nご褒美を\nねだろう",
        "心の声を\n大切に",
        "その笑顔\n今日の\nエネルギー",
        "あなたは\nいつでも\nステキ",
        "今日も\n自分を\n大切に",
        "頑張る\nあなたに\nエール！",
        "自分が\n主役の物語",
        "気づけば\nあなた色の\n世界",
        "自分への\n優しさ忘れずに",
        "あなたの\nペースでOK！",
        "今日の\n一歩に\n自信を",
        "自分の\n感覚を\n信じよう",
        "小さな笑顔を\n積み重ねて",
        "自分を\n褒めるの\n忘れずに！",
        "あなたの\n心も育ってる",
        "今日という日を\n楽しもう",
        "自分の\nペースで\n咲こう",
        "あなたは\nあなたで\n最高！",
        "自分の価値\nちゃんと\n信じて",
        "今日も\nあなたが\n好きです",
        "ゆったり\nのんびり\n自分時間",
        "今日一日の\n自分に\n拍手👏",
        "自分の\n頑張りに\n乾杯！",
        "あなたの毎日\n愛おしい"
    ]
    
    @State private var message: String

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
        _message = State(initialValue: Self.messages.randomElement() ?? "")
    }

    var body: some View {
        ZStack {
            // 全面背景
            bgColor.ignoresSafeArea()

            VStack(spacing: 16) {

                // ────────── 閉じる (×) ボタン ──────────
                HStack {
                    Button {
                        // 完了クロージャを実行
                        onFinish()
                        // そのあと自分自身を閉じる
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 28, weight: .regular))
                            .foregroundColor(.gray)
                            .padding()
                    }
                    Spacer()
                }

                Spacer()

                // ────────── メッセージカード ──────────
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color.white)
                    .frame(maxWidth: 340, maxHeight: 380)
                    .overlay(
                        Text(message)
                            .font(.largeTitle50)
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundStyle(accent)
                            .shadow(color: accent.opacity(0.35), radius: 4, x: 2, y: 2)
                    )
                    .offset(y: -40)                                  // up
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 5)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            VStack {
                HStack {
                    Spacer()
                    Image("右上")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)               // さらに大きく
                        .offset(x: -2, y: 2)                        // 内側へ少しオフセット
                }
                Spacer()
                HStack {
                    Image("左下")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)               // さらに大きく
                        .offset(x: 2, y: -2)                        // 内側へ少しオフセット
                    Spacer()
                }
            }
            .padding(32)
        }
        .navigationBarBackButtonHidden(true) // ← ナビバーの戻るを隠す
    }
}

#Preview {
    NavigationStack {
        // プレビュー用に空のクロージャを渡す
        CelebrationView(onFinish: {})
    }
}
