//
//  CircularCheckBoxView.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-05.
//

import SwiftUI

struct CircularCheckBoxView: View {
    @EnvironmentObject var prefs: GlobalVariables
    @Binding var checked : Bool

    @Binding var trimVal : CGFloat

    var animatableData: CGFloat {
        get {trimVal}
        set { trimVal = newValue }
    }
    var body: some View {
        ZStack {
            if !(prefs.errorNoPhotosSelected) {
                Circle()
                    .trim(from: 0, to: trimVal)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .frame(width: 30, height: 30)
                    .foregroundColor(self.checked ? Color.green : Color.gray)
                    .overlay(
                        Circle()
                            .fill(self.checked ? Color.green : Color.gray.opacity(0.2))
                            .frame(width: 20, height: 20)
                    )
            }
            else {
                Circle()
                    .trim(from: 0, to: trimVal)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                //.frame(width: 70, height: 70)
                    .frame(width: 30, height: 30)
                    .foregroundColor(self.checked ? Color.green : Color.gray)
                //  .foregroundColor(prefs.errorNoPhotosSelected ? Color.red : Color.white)
                    .overlay(
                        Circle()
                           // .fill(Color.red)
                            .fill(prefs.errorNoPhotosSelected ? Color.red : Color.gray.opacity(0.2))
                        //.fill(self.checked ? Color.green : Color.gray.opacity(0.2))
                            .frame(width: 20, height: 20)
                    )
            }

            if checked {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.white)
            }
        }
    }
}
//
//struct CircularCheckBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircularCheckBoxView()
//    }
//}
