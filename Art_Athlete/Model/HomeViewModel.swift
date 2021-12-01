//  Created by josiah on 2021-11-28.
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchActivated: Bool = false
    var searchCancellable : AnyCancellable? = nil
    @Published var searchResults: [Product]?

    @Published var currentType: ProductType = .Wearable

    // Show More Products in CurrentType
    @Published var showMoreCurrentType: Bool = false


    // Sample Products...
    @Published var products: [Product] = [
       // Product(numberInLine: 0, type: .Wearable, title: "Apple Watch", subtitle: "Series 6: Red", count: 2),
       // Product(type: .Phones, title: "iPhone 13", subtitle: "A15 - Pink", count: 3, productImage: "iPhone13"),
       // Product(type: .Folders, title: "iPhone 12", subtitle: "A14 - Blue", count: 4, productImage: "iPhone12"),
    ]

    @Published var filteredProducts: [Product] = []

    @Published var folders: [Product] = []

    init(){
        filterProductByType()

        searchCancellable = $searchText.removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { (str) in
                if str != ""{
                    self.filterProductBySearch(text: str)
                }
                else{
                    self.searchResults = nil
                }
            })
    }

    // Filtering Products based on Product Type...
    func filterProductByType(showAll: Bool = false){
        DispatchQueue.global(qos: .userInteractive).async {

            let filtered = self.products.lazy.filter { product in
                return product.type == self.currentType
            }

            DispatchQueue.main.async {
                self.filteredProducts = filtered.map({ product in
                    return product
                })
            }
        }
    }

    // Filter By Text
    func filterProductBySearch(text: String){
        DispatchQueue.global(qos: .userInteractive).async {

            let results = self.products.filter { product in
                return product.title.lowercased().contains(self.searchText.lowercased())
            }

            DispatchQueue.main.async {
                self.searchResults = results
            }
        }
    }
}
