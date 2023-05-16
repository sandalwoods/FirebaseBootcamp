//
//  FavoriteViewModel.swift
//  FirbaseBootcamp
//
//  Created by kevin on 2023/5/16.
//

import SwiftUI
import Combine


@MainActor
final class FavoriteViewModel: ObservableObject {
    
//    @Published var products: [(userFavoriteProduct: UserFavoriteProduct, product: Product)] = []
    @Published var userFavoriteProducts: [UserFavoriteProduct] = []
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func addListenerForFavorites() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else { return }
//        UserManager.shared.addListenerForALlUserFavoriteProducts(userId: authDataResult.uid) { [weak self] products in
//            self?.userFavoriteProducts = products
//        }
        
        UserManager.shared.addListenerForALlUserFavoriteProducts(userId: authDataResult.uid)
            .sink { completion in
                
            } receiveValue: { [weak self] products in
                self?.userFavoriteProducts = products
            }
            .store(in: &cancellables)

    }
    
//    func getFavorites() {
//        Task {
//            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//            self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
//        }
//    }
    
    func removeFromFavorites(favoriteProductId: String) {
        
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, favoriteProductId: favoriteProductId)
            
//            getFavorites()  //no need to listener
        }
    }

}
