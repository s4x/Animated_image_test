//
//  AppDelegate.swift
//  Animated image
//
//  Created by Serge Nanaev on 29/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

import UIKit
import Nuke

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true

        let pipeline = ImagePipeline { configuration in

            configuration.dataLoader = DataLoader(configuration: {
                // Disable disk caching built into URLSession
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())

            configuration.imageCache = ImageCache()

            configuration.dataCache = try? DataCache(
                name: "imageCache",
                filenameGenerator: {
                    guard let data = $0.cString(using: .utf8) else { return nil }
                    return _nuke_sha1(data, UInt32(data.count))
            })
        }

        Nuke.ImagePipeline.shared = pipeline

        WebPImageDecoder.enable()
        MP4Decoder.enable()

        return true
    }
}

