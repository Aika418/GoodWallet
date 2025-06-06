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

    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack(alignment: .topTrailing) {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
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

    }
}

#Preview {
    HomeView()
}
