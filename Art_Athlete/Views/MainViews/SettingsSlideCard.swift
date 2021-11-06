//
//  SlideOverCard.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-04.
//

import SwiftUI
import SlideOverCard

struct SettingsSlideCard : View {
    @State private var position = CardPosition.top
    @State private var background = BackgroundStyle.blur


    var body: some View {
        ZStack(alignment: Alignment.top) {
            VStack {
                Picker(selection: self.$position, label: Text("Position")) {
                    Text("Bottom").tag(CardPosition.bottom)
                    Text("Middle").tag(CardPosition.middle)
                    Text("Top").tag(CardPosition.top)
                }.pickerStyle(SegmentedPickerStyle())
                Picker(selection: self.$background, label: Text("Background")) {
                    Text("Blur").tag(BackgroundStyle.blur)
                    Text("Clear").tag(BackgroundStyle.clear)
                    Text("Solid").tag(BackgroundStyle.solid)
                }.pickerStyle(SegmentedPickerStyle())
            }.padding().padding(.top, 25)
            SlideOverCard($position, backgroundStyle: $background) {
                VStack {
                    Text("Slide Over Card").font(.title)
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }

}

