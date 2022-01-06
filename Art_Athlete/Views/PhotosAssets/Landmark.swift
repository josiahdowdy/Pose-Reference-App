//Art_Athlete - Created by josiah on 2022-01-06.
import SwiftUI

struct Category:Identifiable {
    var id = UUID()
    var title:String
    var landmarks:[Landmark]
}

struct Landmark:Identifiable {
    var id = UUID()
    var title:String
    var country:String
    var imageName:String {return title}
    var thumbnailName:String {return title + "Thumbnail"}
    var flagName:String {return country }
}


var CategoriesData =  [
    Category(
        title: "Hill",
        landmarks: [
            Landmark(title: "Isle Of Skye", country: "Switzerland"),
            Landmark(title: "Steinweg", country: "MaleStanding"),
            Landmark(title: "Alpine", country: "MaleJump")
        ]
    ),
    Category(
        title: "Castle",
        landmarks: [
            Landmark(title: "Neuschwanstein", country: "Germany"),
            Landmark(title: "Mont St Michel", country: "France")
        ]
    )
]


var landmarksData =  [
    Landmark(title: "Isle Of Skye", country: "Switzerland"),
    Landmark(title: "Steinweg", country: "MaleStanding"),
    Landmark(title: "Alpine", country: "MaleJump"),
    Landmark(title: "Neuschwanstein", country: "Germany"),
    Landmark(title: "Mont St Michel", country: "France")
]
