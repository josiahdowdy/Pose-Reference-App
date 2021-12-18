//
//  RandomSwitch.swift
//  pose-reference
//
//  Created by josiah on 2021-10-19.
//

import SwiftUI

struct toggleSwitch: View {
    @EnvironmentObject var prefs: GlobalVariables
    
    var body: some View {
        Toggle("Random Order", isOn: $prefs.isRandom)
//        HStack{
//            Text("Random Order")
//                .foregroundColor(prefs.isRandom ? .green : .gray)
//            Toggle("Random", isOn: $prefs.isRandom)
//                .labelsHidden()
//                .overlay(
//                    RoundedRectangle(cornerRadius: 15)
//                        .stroke(lineWidth: 2)
//                        .foregroundColor(prefs.isRandom ? .green : .gray)
//                )
//        }

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
