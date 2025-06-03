//
//  ContentView.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("うつくしい")
                .font(.largeTitle60)
                .foregroundColor(.customAccentColor)
            Text("どうして購入しましたか？")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
