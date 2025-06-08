//
//  FloatingButton.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/03.
//

import SwiftUI

struct FloatingButton: View {
    //ボタンが押されたときに呼び出す処理（関数）を外から受け取れる
    //この関数は引数も返り値もない（() -> Void）
    let action: () -> Void
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: action){
                    Image(systemName: "plus")
                        .foregroundColor(.white)//アイコンの色
                        .font(.system(size: 30, weight: .bold))//アイコン大きさと太さ
                        .padding()//アイコンの周りの余白
                        .background(Circle().fill(Color.customAccentColor.opacity(0.8)))//背景を丸く
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
        }
    }
}

#Preview {
    FloatingButton(action: {})
}
