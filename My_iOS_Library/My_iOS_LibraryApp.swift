//
//  My_iOS_LibraryApp.swift
//  My_iOS_Library
//
//  Created by Maël Suard on 01/12/2025.
//

import SwiftUI

@main
struct My_iOS_LibraryApp: App {
    let theme = DefaultTheme()
    let typography = DefaultTypography()
    let spacing = DefaultSpacing()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .theme(theme)
                .typography(typography)
                .spacing(spacing)
        }
    }
}
