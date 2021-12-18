//  Created by josiah on 2021-11-28.

import SwiftUI

struct Product: Identifiable, Hashable {
//class Product: ObservableObject {
   // var numberInLine: Int
    var id = UUID().uuidString
    var isSelected: Bool = false
  //  var type: ProductType
    var title: String
    //var folderName: String
   // var subtitle: String
  //  var description: String = ""
    var count: Int
    //var productImage: String = ""
  //  var quantity: Int = 1

    var getTitle: String {
        title
    }
}

// Type
enum ProductType: String,CaseIterable{
    case Wearable = "Wearable"
    case Laptops = "Laptops"
    case Phones = "Phones"
    case Tablets = "Tablets"
    case Folders = "Folders"
    case Nature = "Nature"
    case Poses = "Poses"
}
