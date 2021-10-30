//
//  SettingsView.swift
//  pose-reference
//
//  Created by josiah on 2021-10-17.
//

import SwiftUI

struct SettingsPrefs<Content> where Content : View {
    
}

struct SettingsMacView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            AdvancedSettingsView()
                .tabItem {
                    Label("Advanced josiah", systemImage: "star")
                }
                .tag(Tabs.advanced)
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}

