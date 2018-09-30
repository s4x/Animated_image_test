//
//  AnimatedImagesViewController.swift
//  Animated image
//
//  Created by Serge Nanaev on 29/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

import UIKit
import GiphyCoreSDK

class AnimatedImagesViewController: UICollectionViewController {

    // MARK: - Properties

    private var storage: TemporaryVideoStorage?
    private var type: AnimatedImageType?
    private var data: [GPHMedia] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.type = AnimatedImageType(rawValue: tabBarItem.tag)

        collectionView?.register(UINib(nibName: GifCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: GifCell.reuseIdentifier)
        collectionView?.register(UINib(nibName: MP4Cell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MP4Cell.reuseIdentifier)
        collectionView?.register(UINib(nibName: WebPCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: WebPCell.reuseIdentifier)

        switch type! {
        case .mp4:
            storage = try? TemporaryVideoStorage()
        default:
            break
        }

        GiphyService().load { (data) in
            self.data = data ?? []
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AnimatedImagesViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let type = self.type else {
            return UICollectionViewCell()
        }

        let media = data[indexPath.row]

        switch type {
        case .gif:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.reuseIdentifier, for: indexPath) as! GifCell
            cell.configure(with: media)
            return cell
        case .mp4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MP4Cell.reuseIdentifier, for: indexPath) as! MP4Cell
            cell.storage = self.storage
            cell.configure(with: media)
            return cell
        case .webp:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebPCell.reuseIdentifier, for: indexPath) as! WebPCell
            cell.configure(with: media)
            return cell
        }
    }
}

extension AnimatedImagesViewController {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width / 3
        return CGSize(width: width, height: width)
    }
}
