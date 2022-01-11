//
//  RandomSwitch.swift
//  pose-reference
//
//  Created by josiah on 2021-10-19.
//

import SwiftUI

struct toggleSwitch: View {
   
    @AppStorage("isRandom") var isRandom = true

    var body: some View {
        if !(UIDevice.current.userInterfaceIdiom == .mac) {
            Toggle("Random Order", isOn: $isRandom)
        } else {
            Button {
                isRandom.toggle()
            } label: {
                HStack {
                    Image(systemName: isRandom ? "checkmark.square" : "square")
                    Text("Random Order")
                }

                


            }
        }



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
