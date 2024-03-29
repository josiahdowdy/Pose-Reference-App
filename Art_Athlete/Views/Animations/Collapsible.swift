// Collapsible.swift - Art_Athlete - Created by josiah on 2021-12-21.
import SwiftUI

struct Collapsible<Content: View>: View {
    @State var label: () -> Text
    @State var content: () -> Content

    @State private var collapsed: Bool = true

    var body: some View {
        VStack {
            Button(
                action: { self.collapsed.toggle() },
                label: {
                    HStack {
                        self.label()
                        Spacer()
                        Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
                    }
                    .padding(.bottom, 1)
                    //.background(Color.white.opacity(0.01))
                }
            )
                .buttonStyle(PlainButtonStyle())
            VStack {
                self.content()
            }

//            .overlay(
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(Color.purple, lineWidth: 5)
//            )
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none)
            .clipped()
            .animation(.easeOut)
            .transition(.slide)
        }
    }
}
