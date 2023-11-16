//
//  CoinImageData.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 01/11/23.
//

import SwiftUI
import Combine

class CoinImageHandler {
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: Coin
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
        
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("Reterieved image from file manager")
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        print("Downloading Image now")
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingHandler.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingHandler.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard 
                    let self = self,
                    let returnedImage = returnedImage
                else { return }
                
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: returnedImage, imageName: imageName, folderName: folderName)
            })
    }
}
