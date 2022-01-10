/*
 Josiah - Oct 29, 2020
 Loaded into NavBar.
 Handles UI for progress bar time.
*/

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                   
                    .animation(.linear)
                    //.animation(.linear(duration: 1), value: 10)
            }.cornerRadius(45.0)
        }
    }
}
