//
//  RandomSwitch.swift
//  pose-reference
//
//  Created by josiah on 2021-10-19.
//

import SwiftUI

struct toggleSwitch: View {
    @EnvironmentObject var prefs: GlobalVariables
    @AppStorage("isRandom") var isRandom = true

    var body: some View {
        Toggle("Random Order", isOn: $isRandom)
    }
}

/*
struct toggleSwitch_Previews: PreviewProvider {
    @State var myVar = true
    
    static var previews: some View {
        toggleSwitch(isRandom: myVar)
    }
}
*/
