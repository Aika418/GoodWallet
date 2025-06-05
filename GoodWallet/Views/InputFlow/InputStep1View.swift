//
//  InputStep1View.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/04.
//
import SwiftUI
import PhotosUI

struct InputStep1View: View {

    @State private var pickedDate: Date = .now
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var rating: Int  = 0
    @State private var photoItem: PhotosPickerItem?
    @State private var image: Image?

    @Environment(\.dismiss) private var dismiss

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
    }

    @ViewBuilder
    private var cardBody: some View {
        VStack(alignment: .leading, spacing: 32) {

            // 行：日付
            HStack(alignment: .center, spacing: 12) {
                fieldLabel("日付")
                DatePicker(
                    "",
                    selection: $pickedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .labelsHidden()
                .padding(.leading, 4)   // ← minor spacing
            }

            // 行：商品名
            HStack {
                fieldLabel("商品名")
                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
            }

            // 行：値段
            HStack {
                fieldLabel("値段")
                TextField("", text: $price)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }

            // 行：満足度
            HStack {
                fieldLabel("満足度")
                ForEach(1...5, id: \.self) { idx in
                    Image(systemName: idx <= rating ? "star.fill" : "star")
                        .foregroundColor(idx <= rating ? .yellow : .gray.opacity(0.4))
                        .onTapGesture { rating = idx }
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
            .onChange(of: photoItem) { item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self),
                       let ui = UIImage(data: data)
                    {
                        image = Image(uiImage: ui)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Spacer()
                NavigationLink(destination: InputStep2View()) {
                    Text("次へ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.pink.opacity(0.8)))
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
            .font(.body)
            .frame(width: 88, alignment: .leading)
    }
}

#Preview {
    NavigationStack { InputStep1View() }
}
