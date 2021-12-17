//MainImageView.swift  -Art_Athlete - Created by josiah on 2021-12-01.

import SwiftUI
import Kingfisher

extension Image {
    init(path: String) {
        self.init(uiImage: UIImage(named: path)!)
    }
}

struct MainImageView: View {
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image(path: "PoseBG2.png") //Pic4.png
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.8) //0.8 is it fills the width 80% of the screen.
                    .frame(width: geo.size.width, height: geo.size.height) //This line makes image fill the container.
                //So I need to put this in a container that will fill the screen.
            }
        }
        .ignoresSafeArea() // 1
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color.gray)
    }
}

//
//struct MainImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainImageView()
//    }
//}
