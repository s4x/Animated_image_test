//
//  GifCell.swift
//  Animated image
//
//  Created by Serge Nanaev on 29/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

import UIKit
import FLAnimatedImage
import GiphyCoreSDK
import Nuke

class GifCell: UICollectionViewCell {

    static let reuseIdentifier = "GifCell"

    @IBOutlet weak var animatedImageView: FLAnimatedImageView!

    func configure(with media: GPHMedia) {
        guard let urlString = media.images?.original?.gifUrl, let url = URL(string: urlString) else {
            return
        }
        Nuke.loadImage(with: url, into: animatedImageView)
    }
}
