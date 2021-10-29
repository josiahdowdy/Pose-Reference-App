//
//  Color.swift
//  pose-reference
//
//  Created by josiah on 2021-10-25.
//

import SwiftUI

extension Color {
    static let brand = Color(red: 75/255, green: 0, blue: 130/255)
    
    static var settingsBackground: Color {
        Color(UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .systemGray5 : .systemGray6
        })
    }
}
