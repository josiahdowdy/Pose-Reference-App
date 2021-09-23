/*
 Josiah - Oct 29, 2020
 User object used to keep track of:
    name, progress, preferences,
 
 */

import Foundation

class UserObject: ObservableObject {
    @Published var userName = "Hagrid"
    @Published var lastUsedSearch = ""
    @Published var favoriteQuote = ""
    
    //Total Time Drawn in all history.
    @Published var totalTimeDrawn: Int = 0
    @Published var totalPosesDrawn = 0
    @Published var totalPosesDrawnToday = 0

    //Certificates
    @Published var currectCert = "beginner"
    @Published var beginnerCert = true
    @Published var intermediateCert = true
    @Published var advancedCert = true
    @Published var masterCert = true
    
}
