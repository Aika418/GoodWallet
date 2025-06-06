import Foundation
import SwiftUI

// ⬇︎コードを追加
extension Color {
    
    static let customAccentColor = Color("AccentColor")
    static let customBackgroundColor = Color("BackgroundColor")
    static let customLineColor = Color("LineColor")
    static let customHokkoriColor = Color("Hokkori")
    static let customKirariColor = Color("Kirari")
    static let customManabiColor = Color("Manabi")
    static let customOsusowakeColor = Color("Osusowake")
    static let customRakuchinColor = Color("Rakuchin")
    static let customSukoyakaColor = Color("Sukoyaka")
    static let customTokimekiColor = Color("Tokimeki")
    static let customWaiwaiColor = Color("Waiwai")
    static let customWakuwakuColor = Color("Wakuwaku")
    static let customNumColor = Color("NumColor")
    
    // ColorからHex文字列に変換するエクステンション
    func toHex() -> String? {
        // CGColorを取得し、RGBAコンポーネントに分解
        guard let components = cgColor?.components else { return nil }
        guard components.count >= 3 else { return nil }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        // RGBA値を16進数文字列に変換
        // アルファ値が1に近い場合はRGB形式、それ以外はARGB形式とします。
        if a >= 0.99 {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(a * 255), lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
