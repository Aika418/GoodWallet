//
//  InvestmentTotalCard.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/03.
//

import SwiftUI

struct InvestmentTotalCard: View {
    var totalAmount: Int = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.customLineColor, lineWidth: 2)
            .frame(height: 200)
            .padding(.horizontal, 40)
            .overlay(
                VStack(alignment: .leading, spacing: 16) {
                    Text("あなたは自分に")
                        .font(.body20)
                        .foregroundColor(.black)
                        .padding(.leading, 0)
                    Text("¥\(totalAmount)")
                        .font(.largeTitle50)
                        .foregroundColor(Color.customNumColor)
                        .padding(.leading, 32)
                    Text("投資しました。")
                        .font(.body20)
                        .foregroundColor(.black)
                        .padding(.leading, 150)
                }
            )
    }
}

#Preview {
    InvestmentTotalCard()
}
