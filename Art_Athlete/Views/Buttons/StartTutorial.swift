//
//  StartTutorial.swift
//  Art_Athlete
//
//  Created by josiah on 2022-01-04.
//

import SwiftUI

struct startTutorial: View {
    @EnvironmentObject var prefs: GlobalVariables
    @AppStorage("isRandom") var isRandom = true

    var body: some View {
        Toggle("Random Order", isOn: $isRandom)
    }
}

//struct StartTutorial_Previews: PreviewProvider {
//    static var previews: some View {
//        StartTutorial()
//    }
//}
