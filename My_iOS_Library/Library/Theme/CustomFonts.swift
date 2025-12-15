//
//  CustomFonts.swift
//  My_iOS_Library
//
//  Example custom font configurations
//

import SwiftUI

// MARK: - Custom Font Families

extension FontFamily {

    // MARK: - Popular Font Examples

    /// SF Pro Display - Apple's premium font
    public static let sfProDisplay = FontFamily(
        regular: "SFProDisplay-Regular",
        medium: "SFProDisplay-Medium",
        semibold: "SFProDisplay-Semibold",
        bold: "SFProDisplay-Bold",
        black: "SFProDisplay-Black",
        italic: "SFProDisplay-RegularItalic",
        mediumItalic: "SFProDisplay-MediumItalic",
        semiboldItalic: "SFProDisplay-SemiboldItalic",
        boldItalic: "SFProDisplay-BoldItalic"
    )

    /// Helvetica Neue
    public static let helveticaNeue = FontFamily(
        regular: "HelveticaNeue",
        medium: "HelveticaNeue-Medium",
        semibold: "HelveticaNeue-Medium",  // No semibold, use medium
        bold: "HelveticaNeue-Bold",
        black: "HelveticaNeue-Bold",  // No black, use bold
        italic: "HelveticaNeue-Italic",
        mediumItalic: "HelveticaNeue-MediumItalic",
        semiboldItalic: "HelveticaNeue-MediumItalic",
        boldItalic: "HelveticaNeue-BoldItalic"
    )

    /// Avenir Next
    public static let avenirNext = FontFamily(
        regular: "AvenirNext-Regular",
        medium: "AvenirNext-Medium",
        semibold: "AvenirNext-DemiBold",
        bold: "AvenirNext-Bold",
        black: "AvenirNext-Heavy",
        italic: "AvenirNext-Italic",
        mediumItalic: "AvenirNext-MediumItalic",
        semiboldItalic: "AvenirNext-DemiBoldItalic",
        boldItalic: "AvenirNext-BoldItalic"
    )

    /// Montserrat - Popular Google Font
    public static let montserrat = FontFamily(
        regular: "Montserrat-Regular",
        medium: "Montserrat-Medium",
        semibold: "Montserrat-SemiBold",
        bold: "Montserrat-Bold",
        black: "Montserrat-Black",
        italic: "Montserrat-Italic",
        mediumItalic: "Montserrat-MediumItalic",
        semiboldItalic: "Montserrat-SemiBoldItalic",
        boldItalic: "Montserrat-BoldItalic"
    )

    /// Poppins - Modern Google Font
    public static let poppins = FontFamily(
        regular: "Poppins-Regular",
        medium: "Poppins-Medium",
        semibold: "Poppins-SemiBold",
        bold: "Poppins-Bold",
        black: "Poppins-Black",
        italic: "Poppins-Italic",
        mediumItalic: "Poppins-MediumItalic",
        semiboldItalic: "Poppins-SemiBoldItalic",
        boldItalic: "Poppins-BoldItalic"
    )

    /// Roboto - Android's system font
    public static let roboto = FontFamily(
        regular: "Roboto-Regular",
        medium: "Roboto-Medium",
        semibold: "Roboto-Medium",  // No semibold, use medium
        bold: "Roboto-Bold",
        black: "Roboto-Black",
        italic: "Roboto-Italic",
        mediumItalic: "Roboto-MediumItalic",
        semiboldItalic: "Roboto-MediumItalic",
        boldItalic: "Roboto-BoldItalic"
    )
}

// MARK: - Typography Presets

extension DefaultTypography {

    /// Clean and modern typography using Inter
    public static let modern = DefaultTypography(fontFamily: .inter)

    /// Classic iOS feel with SF Pro Display
    public static let apple = DefaultTypography(fontFamily: .sfProDisplay)

    /// Friendly and approachable with Poppins
    public static let friendly = DefaultTypography(fontFamily: .poppins)

    /// Professional with Helvetica Neue
    public static let professional = DefaultTypography(fontFamily: .helveticaNeue)

    /// Elegant with Avenir Next
    public static let elegant = DefaultTypography(fontFamily: .avenirNext)
}

// MARK: - Font Loading Helper

public struct FontLoader {

    /// Loads all fonts for a given font family
    public static func loadFontFamily(_ family: FontFamily) {
        let fonts = [
            family.regular,
            family.medium,
            family.semibold,
            family.bold,
            family.black,
            family.italic,
            family.mediumItalic,
            family.semiboldItalic,
            family.boldItalic
        ]

        for fontName in fonts.compactMap({ $0 }) {
            if !isFontLoaded(fontName) {
                loadFont(fontName)
            }
        }
    }

    /// Check if a font is already loaded
    private static func isFontLoaded(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 12) != nil
    }

    /// Load a single font
    private static func loadFont(_ fontName: String) {
        // Try common font extensions
        let extensions = ["ttf", "otf"]

        for ext in extensions {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: ext),
               let fontData = try? Data(contentsOf: fontURL) as CFData,
               let provider = CGDataProvider(data: fontData),
               let font = CGFont(provider) {

                CTFontManagerRegisterGraphicsFont(font, nil)
                print("✅ Loaded font: \(fontName)")
                return
            }
        }

        print("⚠️ Failed to load font: \(fontName)")
    }

    /// Print all available fonts (useful for debugging)
    public static func printAvailableFonts() {
        for family in UIFont.familyNames.sorted() {
            print("\n📝 \(family):")
            for font in UIFont.fontNames(forFamilyName: family) {
                print("   - \(font)")
            }
        }
    }
}

// MARK: - Info.plist Helper

/*
 To use custom fonts, add this to your Info.plist:

 <key>UIAppFonts</key>
 <array>
     <string>Inter-Regular.ttf</string>
     <string>Inter-Medium.ttf</string>
     <string>Inter-SemiBold.ttf</string>
     <string>Inter-Bold.ttf</string>
     <string>Inter-Black.ttf</string>
     <string>Inter-Italic.ttf</string>
     <string>Inter-MediumItalic.ttf</string>
     <string>Inter-SemiBoldItalic.ttf</string>
     <string>Inter-BoldItalic.ttf</string>
 </array>

 Or for other font families, replace with their respective file names.
 */