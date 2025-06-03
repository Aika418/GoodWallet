//
//  HomeView.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/03.
//
import SwiftUI

struct HomeView: View {
    @State private var isPresentingInput = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 10) {
                    Spacer().frame(height: 50)
                    
                    BubbleChartView()
                        .padding(.horizontal, 16)
                    
                    Spacer()
                    InvestmentTotalCard()
                        .padding(.bottom, 50)
                }

                // FloatingButtonを右上に配置
                FloatingButton(action: {
                    isPresentingInput = true
                })
                .padding(.bottom, 750)
                .padding(.trailing, 20)
                .fullScreenCover(isPresented: $isPresentingInput) {
                    InputFlowView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
