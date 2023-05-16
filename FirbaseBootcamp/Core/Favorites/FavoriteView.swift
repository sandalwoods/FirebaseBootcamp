//
//  FavoriteView.swift
//  FirbaseBootcamp
//
//  Created by kevin on 2023/5/15.
//

import SwiftUI

@MainActor
final class FavoriteViewModel: ObservableObject {
    
//    @Published var products: [(userFavoriteProduct: UserFavoriteProduct, product: Product)] = []
    @Published var userFavoriteProducts: [UserFavoriteProduct] = []
    
//    func getFavorites() {
//        Task {
//            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//            let userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
//
//            var localArray: [(userFavoriteProduct: UserFavoriteProduct, product: Product)] = []
//            for userFavoriteProduct in userFavoriteProducts {
//                if let prodcut = try? await ProductsManager.shared.getProduct(productId: String(userFavoriteProduct.productId)) {
//                    localArray.append((userFavoriteProduct, prodcut))
//                }
//            }
//
//            self.products = localArray
//        }
//    }
    
    func getFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
        }
    }
    
    func removeFromFavorites(favoriteProductId: String) {
        
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
            
            getFavorites()
        }
    }

}

struct FavoriteView: View {
    
    @StateObject private var viewModel = FavoriteViewModel()
    
    var body: some View {
        List {
//            ForEach(viewModel.products, id: \.userFavoriteProduct.id.self) { item in
//                ProductCellView(product: item.product)
//                    .contextMenu {
//                        Button("Remove from favorites") {
//                            viewModel.removeFromFavorites(favoriteProductId: item.userFavoriteProduct.id)
//                        }
//                    }
//            }
            
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu {
                        Button("Remove from favorites") {
                            viewModel.removeFromFavorites(favoriteProductId: item.id)
                        }
                    }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.getFavorites()
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoriteView()
        }
    }
}
