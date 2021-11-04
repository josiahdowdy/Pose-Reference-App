//
//  Tab.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-02.
//

import SwiftUI

// Tab Model and sample Intro Tabs....
struct Tab: Identifiable{
    var id = UUID().uuidString
    var title: String
    var subTitle: String
    var description: String
    var image: String
    var color: Color
}

// Add more tabs for more intro screens....
var tabs: [Tab] = [
    
    Tab(title: "TRAIN", subTitle: "Sketch Daily", description: "Warm up each day with timed drawing sessions, loosen up and let your pencil flow.", image: "Pic1",color: Color("DarkGrey")),
    Tab(title: "STUDY", subTitle: "Learn Anatomy", description: "Understand how the bones and muscles move. Learn humans and animals!", image: "Pic2",color: Color("Yellow")),
    Tab(title: "INSPIRE", subTitle: "Track Your Progress", description: "Watch as yourself grow as an artist as you practice more and more, whether you feel like it or not.", image: "Pic3",color: Color("Green")),
]
