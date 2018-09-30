//
//  TemporaryVideoStorage.swift
//  Animated image
//
//  Created by Serge Nanaev on 30/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

import Nuke

final class TemporaryVideoStorage {
    private let path: URL
    private let _queue = DispatchQueue(label: "sn.animatedimage.TemporaryVideoStorage.Queue")

    init() throws {
        guard let root = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: nil)
        }
        self.path = root.appendingPathComponent("sn.animatedimage.TemporaryVideoStorage.Queue", isDirectory: true)
        // Clear the contents that could potentially was left from the previous session.
        try? FileManager.default.removeItem(at: path)
        try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
    }

    func storeData(_ data: Data, _ completion: @escaping (URL) -> Void) {
        _queue.async {
            let url = self.path.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
            try? data.write(to: url) // Ignore that write may fail in some cases
            DispatchQueue.main.async {
                completion(url)
            }
        }
    }

    func removeData(for url: URL) {
        _queue.async {
            try? FileManager.default.removeItem(at: url)
        }
    }
}
