//
//  WebPCell.swift
//  Animated image
//
//  Created by Serge Nanaev on 29/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

import UIKit
import GiphyCoreSDK
import Nuke
import YYImage

class WebPCell: UICollectionViewCell {
    static let reuseIdentifier = "WebPCell"

    @IBOutlet weak var animatedImageView: YYAnimatedImageView!

    func configure(with media: GPHMedia) {
        guard let urlString = media.images?.original?.webPUrl, let url = URL(string: urlString) else {
            return
        }
        Nuke.loadImage(with: url, into: animatedImageView)
    }
}

extension YYAnimatedImageView {
    open override func display(image: Image?) {
        guard image != nil else {
            self.image = nil
            return
        }
        if let data = image?.animatedImageData {
            self.image = image
            DispatchQueue.global().async {
                let animatedImage = YYImage(data: data)
                DispatchQueue.main.async {
                    // If view is still displaying the same image
                    if self.image === image {
                        self.image = animatedImage
                    }
                }
            }
        } else {
            self.image = image
        }
    }
}
