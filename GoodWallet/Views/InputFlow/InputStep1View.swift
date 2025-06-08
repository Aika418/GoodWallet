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

            // 行：日付
            HStack(alignment: .center, spacing: 12) {
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
                .padding(.leading, 4)   // ← minor spacing
                .font(.body20)
            }

            // 行：商品名
            HStack {
                fieldLabel("商品名")
                    .font(.body20)
                TextField("", text: $purchase.name)
                    .textFieldStyle(.roundedBorder)
                    .font(.body20)
            }

            // 行：値段
            HStack {
                fieldLabel("値段")
                    .font(.body20)
                TextField("", text: Binding(
                    get: { String(purchase.price) },
                    set: { purchase.price = Int($0) ?? purchase.price }
                ))
                .font(.body20)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            }

            // 行：満足度
            HStack {
                fieldLabel("満足度")
                    .font(.body20)
                ForEach(1...5, id: \.self) { idx in
                    Image(systemName: idx <= purchase.rating ? "star.fill" : "star")
                        .foregroundColor(idx <= purchase.rating ? .yellow : .gray.opacity(0.4))
                        .onTapGesture { purchase.rating = idx }
                }
            }

            // 写真選択
            PhotosPicker(selection: $photoItem, matching: .images) {
                ZStack {
                    if let img = image {
                        img.resizable()
                    } else {
                        Color.gray.opacity(0.2)
                        Image(systemName: "camera.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 8))
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

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .frame(width: 88, alignment: .leading)
    }
}

#Preview {
    NavigationStack { InputStep1View(purchase: Purchase()) }
}
