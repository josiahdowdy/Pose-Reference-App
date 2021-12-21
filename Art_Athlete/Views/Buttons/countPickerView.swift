//countPickerView.swift - Art_Athlete - Created by josiah on 2021-11-10.

import SwiftUI

struct countPickerView: View {
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var prefs: GlobalVariables

    var body: some View {
        HStack {
            Text("Count:").padding(10)
                .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
            // Length time of pose
            Picker("Numbers", selection: $prefs.selectorCountTime) {
                ForEach(0 ..< prefs.homeManyPhotosToDraw.count) { index in
                    Text(String(self.prefs.homeManyPhotosToDraw[index])).tag(index)
                        .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(10)
        }
        .padding(.leading, 50)
        .padding(.trailing, 50)
    }
}

struct countPickerView_Previews: PreviewProvider {
    static var previews: some View {
        countPickerView()
    }
}
