//
//  SettingsRow.swift
//  pose-reference
//
//  Created by josiah on 2021-10-25.
//

import SwiftUI

struct SettingsRow: View {
    var title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .foregroundColor(.brand)
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .foregroundColor(.settingsBackground)
    }
}
