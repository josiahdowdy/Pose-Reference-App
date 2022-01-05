//
//  StartTutorial.swift
//  Art_Athlete
//
//  Created by josiah on 2022-01-04.
//

import SwiftUI

struct startTutorial: View {
    @EnvironmentObject var prefs: GlobalVariables
    @AppStorage("startTutorial") var startTutorial = false

    var body: some View {
        Button {
            startTutorial = true
            prefs.showSettings = false
        } label: {
            Text("Start Tutorial")
        }
    }
}

//struct StartTutorial_Previews: PreviewProvider {
//    static var previews: some View {
//        StartTutorial()
//    }
//}
