//
//  CircularCheckBoxView.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-05.
//

import SwiftUI

struct CircularCheckBoxView: View {
    @Binding var checked : Bool

    @Binding var trimVal : CGFloat

    var animatableData: CGFloat {
        get {trimVal}
        set { trimVal = newValue }
    }
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: trimVal)
                .stroke(style: StrokeStyle(lineWidth: 2))
                //.frame(width: 70, height: 70)
                .frame(width: 50, height: 50)
                .foregroundColor(self.checked ? Color.green : Color.gray)
                .overlay(
                    Circle()
                        .fill(self.checked ? Color.green : Color.gray.opacity(0.2))
                        //.frame(width: 60, height: 60))
                        .frame(width: 40, height: 40))
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
