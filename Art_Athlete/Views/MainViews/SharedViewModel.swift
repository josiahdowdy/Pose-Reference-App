//AA -  Created by josiah on 2021-11-28.

import SwiftUI

class SharedViewModel: ObservableObject {

    // Liked Products
    @Published var likedProducts: [Product] = []

    @Published var basketItems: [Product] = []

    // Detail Page
    @Published var showProductDetail: Bool = false
    @Published var detailProduct: Product?
    @Published var fromSearchDetail: Bool = false

    func getBasketTotal()->Int{

        var total: Int = 0

        basketItems.forEach { product in

            let countString = String(product.count)
            let priceStr = countString.replacingOccurrences(of: "$", with: "") as NSString

            let quantity = 0//product.quantity
            let priceWithQuantity = quantity * priceStr.integerValue

            total += priceWithQuantity
        }

        return total
    }
}
