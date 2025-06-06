//
//  HomeView.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/03.
//
import SwiftUI

struct HomeView: View {
    @State private var navPath = NavigationPath()

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
                switch route {
                case .inputStep1:
                    InputStep1View()
                case .inputStep2:
                    InputStep2View()
                case .inputStep3:
                    InputStep3View()
                default:
                    // AppRouteの他のケース（例: .celebration）はここで処理しない
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
