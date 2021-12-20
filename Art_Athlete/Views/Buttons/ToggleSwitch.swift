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
        /*
        if !(UIDevice.current.userInterfaceIdiom == .mac) {
            Toggle("Random Order", isOn: $isRandom)
        } else {
            HStack{
                Toggle("Random Order", isOn: $isRandom)
                    .toggleStyle(DefaultToggleStyle())
//                Text("Random Order")
//                    .foregroundColor(isRandom ? .green : .gray)

                    //.labelsHidden()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 15)
//                            .stroke(lineWidth: 2)
//                            .foregroundColor(isRandom ? .green : .gray)
//                    )
            }
        }
        //$prefs.isRandom)
*/
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
