import SwiftUI

enum EchoesColor {
    static let bgPrimary = Color(hex: 0x000000)
    static let bgSecondary = Color(hex: 0x1C1C1E)
    static let bgTertiary = Color(hex: 0x2C2C2E)
    static let gold = Color(hex: 0xD4AA40)
    static let goldSoft = Color(hex: 0xEAD07A)
    static let teal = Color(hex: 0x00BFA5)
    static let purple = Color(hex: 0x8E6DAF)
    static let red = Color(hex: 0xFF453A)
    static let textPrimary = Color(hex: 0xFFFFFF)
    static let textSecondary = Color(hex: 0x98989F)
    static let textMuted = Color(hex: 0x6C6C74)
    static let border = Color(hex: 0x38383A)
}

enum EchoesSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

enum EchoesRadius {
    static let xs: CGFloat = 2
    static let sm: CGFloat = 4
    static let md: CGFloat = 12
    static let lg: CGFloat = 22
    static let full: CGFloat = 9999
}

enum EchoesFont {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
    static let title = Font.system(size: 22, weight: .bold, design: .default)
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let subhead = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption = Font.system(size: 11, weight: .regular, design: .default)
    static let timer = Font.system(size: 48, weight: .bold, design: .monospaced)
}

extension Color {
    init(hex: UInt64, alpha: Double = 1) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double(hex & 0xff) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
