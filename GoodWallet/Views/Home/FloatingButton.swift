//
//  FloatingButton.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/03.
//

import SwiftUI

struct FloatingButton: View {
    let action: () -> Void
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: action){
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                        .padding()
                        .background(Circle().fill(Color.customAccentColor.opacity(0.8)))
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
        }
    }
}

#Preview {
    FloatingButton(action: {})
}
