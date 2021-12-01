//
//  MainImageView.swift
//  Art_Athlete
//
//  Created by josiah on 2021-12-01.
//

import SwiftUI
import Kingfisher

extension Image {
    init(path: String) {
        self.init(uiImage: UIImage(named: path)!)
    }
}


struct MainImageView: View {

    var body: some View {
        HStack {
            GeometryReader { geo in
                Image(path: "Pic4.png")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.8)
                    .frame(width: geo.size.width, height: geo.size.height) //This line makes image fill the container.

                //So I need to put this in a container that will fill the screen.
            }

        }
        .background(Color.pink)


    }
}


//
//struct MainImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainImageView()
//    }
//}
