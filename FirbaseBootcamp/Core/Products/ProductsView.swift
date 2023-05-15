//
//  ProductsView.swift
//  FirbaseBootcamp
//
//  Created by kevin on 2023/5/14.
//

import SwiftUI

@MainActor
final class ProductsViewModel: ObservableObject {
    
    //    func downloadProductAndUploadToFirebase() {
    //
    //        guard let url = URL(string: "https://dummyjson.com/products") else { return }
    //
    //        Task {
    //            do {
    //                let (data, _) = try await URLSession.shared.data(from: url)
    //                let products = try JSONDecoder().decode(ProductArray.self, from: data)
    //                let productArray = products.products
    //
    //                for product in productArray {
    //                    try? await ProductsManager.shared.uploadProduct(product: product)
    //                }
    //
    //                print("SUCCESS")
    //                print(products.products.count)
    //            } catch {
    //                print(error)
    //            }
    //        }
    //    }
    
    @Published var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    
//    func getAllProducts() async throws {
//        self.products = try await ProductsManager.shared.getAllProducts()
//    }
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDecending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filtereSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.getProducts()
//        switch option {
//        case .noFilter:
//            self.products = try await ProductsManager.shared.getAllProducts()
//        case .priceHigh:
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: true)
//        case .priceLow:
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: false)
//        }
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case smartphones
        case laptops
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.getProducts()
        //        switch option {
        //        case .noCategory:
        //            self.products = try await ProductsManager.shared.getAllProducts()
        //        case .smartphones, .laptops, .fragrances:
        //            self.products = try await ProductsManager.shared.getAllProductsForCategory(category: option.rawValue)
        //            self.selectedCategory = option
    }
    
    func getProducts() {
        Task {
            self.products = try await ProductsManager.shared.getAllProductsByPrice(priceDescending: selectedFilter?.priceDecending, forCategory: selectedCategory?.categoryKey)
        }
    }
}

struct ProductsView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")"){
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.filtereSelected(option: option)
                            }
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")"){
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.categorySelected(option: option)
                            }
                        }
                    }
                }
            }
        })
        .onAppear {
           viewModel.getProducts()
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProductsView()
        }
    }
}
