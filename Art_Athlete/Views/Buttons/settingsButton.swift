//
//  settingsButton.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-19.
//

import SwiftUI

struct settingsButton: View {
    //@Binding var prefs: GlobalVariables
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var prefs: GlobalVariables

    var body: some View {
        Button(action: {
            // imageData[current].description = description
            showSettings()
            // showSheet = false
        }, label: {
            Image(systemName: "gearshape")
                .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
        })
    }

    private func showSettings() {
        prefs.showSettings.toggle()
    }
}

//struct settingsButton_Previews: PreviewProvider {
//    static var previews: some View {
//        settingsButton()
//    }
//}
