//
//  GeneralSettingsView.swift
//  pose-reference
//
//  Created by josiah on 2021-10-17.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("showPreview") private var showPreview = true
    @AppStorage("fontSize") private var fontSize = 12.0
    
    
    var body: some View {
        Form {
            Toggle("Show Previews", isOn: $showPreview)
            Slider(value: $fontSize, in: 9...96) {
                Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}





//Change Timer Style
//Put this in settings.
/*
 Button(action: {
 print("\nTimer Style\n")
 //changeTimer.toggle()
 prefs.changeTimer.toggle()
 }) {
 Image(systemName: prefs.changeTimer ? "clock.fill" : "clock" ) //Text("Grayscale")
 }.buttonStyle(BorderlessButtonStyle())
 .buttonStyle(bounceButtonStyle())
 */
