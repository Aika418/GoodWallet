//
//  FontStyles.swift
//  GoodWallet
//
//  Created by 塩入愛佳 on 2025/06/03.
//

import Foundation
import SwiftUI
//フォント設定
extension Font {
    static var largeTitle80: Font {
        .custom("RoundedMplus1c-Regular", size: 80, relativeTo: .largeTitle)
    }
    
    static var largeTitle60: Font {
        .custom("RoundedMplus1c-Regular", size: 60, relativeTo: .largeTitle)
    }
    static var largeTitle50: Font {
        .custom("RoundedMplus1c-Regular", size: 50, relativeTo: .largeTitle)
    }
    static var title40: Font {
        .custom("RoundedMplus1c-Regular", size: 40, relativeTo: .title)
    }
    static var title30: Font {
        .custom("RoundedMplus1c-Regular", size: 30, relativeTo: .title)
    }
    static var title25: Font {
        .custom("RoundedMplus1c-Regular", size: 25, relativeTo: .title2)
    }
    static var body20: Font {
        .custom("RoundedMplus1c-Regular", size: 20, relativeTo: .body)
    }
    static var caption15: Font {
        .custom("MRoundedMplus1c-Regular", size: 15, relativeTo: .caption)
    }
    static var caption12: Font {
        .custom("MRoundedMplus1c-Regular", size: 12, relativeTo: .caption)
    }
    static var caption17: Font {
        .custom("MRoundedMplus1c-Regular", size: 17, relativeTo: .caption)
    }
}
