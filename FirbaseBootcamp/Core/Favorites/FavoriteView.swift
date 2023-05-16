//
//  FavoriteView.swift
//  FirbaseBootcamp
//
//  Created by kevin on 2023/5/15.
//

import SwiftUI
//import Combine

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
        .onFirstAppear {
            viewModel.addListenerForFavorites()
        }
//        .onAppear {
//            if !didAppear {
//                viewModel.addListenerForFavorites()
//            }
//        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoriteView()
        }
    }
}
