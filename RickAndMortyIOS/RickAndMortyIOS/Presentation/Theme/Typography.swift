import SwiftUI

struct CustomFonts {
    static let interBold = "Inter-Bold"
    static let interRegular = "Inter-Regular"
}

extension Font {
    static let headlineLarge = Font.custom(CustomFonts.interBold, size: 28)
    static let headlineMedium = Font.custom(CustomFonts.interBold, size: 20)
    static let headlineSmall = Font.custom(CustomFonts.interBold, size: 16)
    
    static let bodyLarge = Font.custom(CustomFonts.interRegular, size: 18)
    static let bodyMedium = Font.custom(CustomFonts.interRegular, size: 16)
    static let bodySmall = Font.custom(CustomFonts.interRegular, size: 14)
    
    static let labelMedium = Font.custom(CustomFonts.interRegular, size: 12)
}
