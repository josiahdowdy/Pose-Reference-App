//
//  timePickerView.swift
//  pose-reference
//
//  Created by josiah on 2021-10-19.
//

import SwiftUI

struct timePickerView: View {
    @EnvironmentObject var prefs: GlobalVariables
    
    var body: some View {
        HStack {
            Text("Length:").padding(10)
            // Length time of pose
            Picker("Numbers", selection: $prefs.selectorIndexTime) {
                ForEach(0 ..< prefs.time.count) { index in
                    Text(self.prefs.time[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct timePickerView_Previews: PreviewProvider {
    static var previews: some View {
        timePickerView()
    }
}
