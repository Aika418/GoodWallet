//
//  InputStep1View.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/04.
//
import SwiftUI
import PhotosUI
import SwiftData

struct InputStep1View: View {

    @State private var pickedDate: Date = .now
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var rating: Int  = 0
    @State private var photoItem: PhotosPickerItem?
    @State private var image: Image?

    @Environment(\.dismiss) private var dismiss
    @Bindable var purchase: Purchase

    var body: some View {
        ScrollView {
            VStack {
                cardBody
                Spacer(minLength: 30)
            }
            .frame(maxWidth: .infinity,
                   minHeight: UIScreen.main.bounds.height)
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
        

    @ViewBuilder
    private var cardBody: some View {
        VStack(alignment: .leading, spacing: 32) {

            // ===== 1 列目（ラベル）と 2 列目（入力欄）を Grid でそろえる =====
            Grid(alignment: .leading, horizontalSpacing: 36, verticalSpacing: 24) {

                // 行：日付
                GridRow {
                    fieldLabel("日付")
                        .font(.body20)

                    DatePicker(
                        "",
                        selection: $purchase.date,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.compact)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .labelsHidden()
                    .font(.body20)
                }

                // 行：商品名
                GridRow {
                    fieldLabel("商品名")
                        .font(.body20)

                    TextField("", text: $purchase.name)
                        .textFieldStyle(.roundedBorder)
                        .font(.body20)
                }

                // 行：値段
                GridRow {
                    fieldLabel("値段")
                        .font(.body20)

                    TextField("", text: Binding(
                        get: { purchase.price == 0 ? "" : String(purchase.price) },
                        set: { purchase.price = Int($0) ?? 0 }
                    ))
                    .font(.body20)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                }

                // 行：満足度
                GridRow {
                    fieldLabel("満足度")
                        .font(.body20)

                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { idx in
                            Image(systemName: idx <= purchase.rating ? "star.fill" : "star")
                                .foregroundColor(idx <= purchase.rating ? .yellow : .gray.opacity(0.4))
                                .onTapGesture { purchase.rating = idx }
                        }
                    }
                }
            }

            // 写真選択
            PhotosPicker(selection: $photoItem, matching: .images) {
                GeometryReader { geo in
                    let side = geo.size.width * 0.55        // 画面幅の 55% を一辺とする正方形
                    ZStack {
                        if let img = image {
                            img.resizable()
                                .scaledToFill()
                        } else {
                            Color.gray.opacity(0.2)
                            Image(systemName: "camera.fill")
                                .font(.system(size: side * 0.18))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: side, height: side)       // 可変サイズ
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(maxWidth: .infinity, alignment: .center)   // GeometryReader 内で中央寄せ
                }
                .frame(height: UIScreen.main.bounds.width * 0.55)   // GeometryReader の高さ確保
            }
            //写真が選ばれたら、データをアプリのDocumentフォルダに保存
            .onChange(of: photoItem) { item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self),
                       let ui = UIImage(data: data)
                    {
                        image = Image(uiImage: ui)

                        // 画像データをファイルに保存し、そのパスをpurchase.photoURLsに追加
                        let fileManager = FileManager.default
                        // アプリのDocumentsディレクトリのURLを取得
                        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                            print("Error: Documents directory not found.")
                            return
                        }

                        // 一意のファイル名を生成 (例: UUID.jpeg)
                        let fileName = UUID().uuidString + ".jpeg"
                        let fileURL = documentsDirectory.appendingPathComponent(fileName)

                        do {
                            // ファイルにデータを書き込み（JPEG形式で圧縮）
                            if let jpegData = ui.jpegData(compressionQuality: 0.9) { // 圧縮率0.9でJPEGデータを取得
                                try jpegData.write(to: fileURL)
                                // 保存に成功したら、ファイルパスをpurchase.photoURLsに追加
                                // URLのpathプロパティを使用（String型）
                                purchase.photoURLs.append(fileURL.path)
                                print("Successfully saved image to: \(fileURL.path)") // デバッグ出力
                            } else {
                                print("Error: Could not get JPEG data from UIImage.")
                            }
                        } catch {
                            // ファイル書き込みエラー
                            print("Error saving image: \(error.localizedDescription)") // デバッグ出力
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Spacer()
                NavigationLink(destination: InputStep2View(purchase: purchase)) {
                    Text("次へ")
                        .font(.title25)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(Capsule().fill(Color.customAccentColor.opacity(0.8)))
                }
                .buttonStyle(.plain)   // デフォルトの青ハイライトを無効に
            }
            .padding(.top, 50)
        }
        .padding(.top, 32)
        .padding(24)
    }

/// ラベル列（「日付」「商品名」…）の幅を統一するためのヘルパー。
/// `.frame` を使わず、最も長い語を透明オーバーレイとして重ね
/// 各ラベルを同じレイアウト幅にする。
private func fieldLabel(_ text: String) -> some View {
    // この画面で最も長い語。「満足度」を基準に幅を揃える
    let widestLabel = "満足度"

    return Text(text)
        .lineLimit(1)
        .minimumScaleFactor(0.7)      // 長過ぎる場合は 70% まで縮小
        .multilineTextAlignment(.leading)
        // 透明テキストを重ねてラベル幅を確保
        .overlay(
            Text(widestLabel)
                .opacity(0)           // ← 表示はしない
        )
}
}

#Preview {
    NavigationStack { InputStep1View(purchase: Purchase()) }
}
