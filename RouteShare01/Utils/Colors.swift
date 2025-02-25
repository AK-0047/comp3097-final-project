//
//  Colors.swift
//  RouteShare01
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-24.
//

import SwiftUI

struct AppColors {
    /// Cream background
    static let background = Color(hex: "#FFFAF0")
    
    /// Orange for buttons and other interactive elements
    static let buttonBackground = Color(hex: "#FF9500")
    
    /// Brown for general text/content
    static let contentText = Color(hex: "#594A3A")
    
    /// White for button text
    static let buttonText = Color(hex: "#FFFFFF")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanLocation = 1
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
