//Art_Athlete - Created by josiah on 2022-01-06.
import SwiftUI

struct PhotoAssets: View {
    // var landmarks = landmarksData
    var posePhotos = posePhotosData
    var folders = folderNames
    var body: some View {
     //   NavigationView {
//        List {
//            ForEach(folders, id: \.self) { folder in
//                FolderButtonRowView(folder: folder, selectedBtn: self.$selectedBtn) //2
//                   // .environmentObject(homeData)
//            }
//        //    .onDelete(perform: removeFolders)
//        }

            List() {
                ForEach(folders) { folder in
                    Text(folder.name)
                } // ForEach
            } //List

//            List() {
//                ForEach(posePhotos) { photo in
//                    //LandmarkRow(photo:photo)
//                    //   Image(photo.thumbnailName).cornerRadius(8)
//                    Image(photo.photoName)
//                } // ForEach
//            } // List
      //  } // NavView
    } // Body
}

struct LandmarkRow: View {
    var landmark:Landmark
    var body: some View {
        HStack {
            Image(landmark.thumbnailName).cornerRadius(8)
            VStack(alignment: .leading) {
                Text(landmark.title).bold()
                Text(landmark.country).foregroundColor(.gray)
            }
            Spacer()
            Image(landmark.flagName)
        }
    }
}


    //struct ContentView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        LandmarkList(landmarks:landmarksData)
    //    }
    //}
