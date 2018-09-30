//
//  MP4Cell.swift
//  Animated image
//
//  Created by Serge Nanaev on 29/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

import Nuke
import AVKit
import GiphyCoreSDK

class MP4Cell: UICollectionViewCell {
    static let reuseIdentifier = "MP4Cell"

    // MARK: - Properties

    var storage: TemporaryVideoStorage?

    private var requestId: Int = 0

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerLooper: AnyObject?

    private var videoURL: URL?

    // MARK: - UICollectionViewCell

    override func prepareForReuse() {
        super.prepareForReuse()

        if let videoURL = videoURL {
            storage?.removeData(for: videoURL)
        }
    }

    // MARK: - Internal methods

    func configure(with media: GPHMedia) {
        guard let urlString = media.images?.original?.mp4Url, let url = URL(string: urlString) else {
            return
        }
        Nuke.loadImage(with: url, into: self)
    }

    // MARK: - Private methods

    private func _playVideoAtURL(_ url: URL) {
        let playerItem = AVPlayerItem(url: url)
        if let player = self.player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            let player = AVQueuePlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: player)
            if #available(iOS 10.0, *) {
                self.playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
            }
            contentView.layer.addSublayer(playerLayer)
            playerLayer.frame = contentView.bounds

            player.play()

            self.player = player
            self.playerLayer = playerLayer
        }
    }
}


extension MP4Cell: Nuke.ImageDisplaying {
    func display(image: Image?) {
        prepareForReuse()

        guard let data = image?.animatedImageData else {
            return
        }

        self.requestId += 1
        let requestId = self.requestId

        storage?.storeData(data) { [weak self] url in
            guard self?.requestId == requestId else { return }
            self?._playVideoAtURL(url)
        }
    }
}
