//
//  MP4Decoder.swift
//  Animated image
//
//  Created by Serge Nanaev on 30/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

import Nuke

final class MP4Decoder: ImageDecoding {
    func decode(data: Data, isFinal: Bool) -> Image? {
        guard isFinal else { return nil }

        let image = Image()
        image.animatedImageData = data
        image.mimeType = "video/mp4"
        return image
    }

    private static func _match(_ data: Data, offset: Int = 0, _ numbers: [UInt8]) -> Bool {
        guard data.count >= numbers.count + offset else { return false }
        return !zip(numbers.indices, numbers).contains { (index, number) in
            data[index + offset] != number
        }
    }

    private static var isEnabled: Bool = false

    static func enable() {
        guard !isEnabled else { return }
        isEnabled = true
        ImageDecoderRegistry.shared.register {
            // FIXME: these magic numbers are for:
            // ftypisom - ISO Base Media file (MPEG-4) v1
            // There are a bunch of other ways to create MP4
            // https://www.garykessler.net/library/file_sigs.html
            guard _match($0.data, offset: 4, [0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D]) else {
                return nil
            }
            return MP4Decoder()
        }
    }
}

private var _imageFormatAK = "Nuke.ImageFormat.AssociatedKey"

private extension Image {
    // At some point going to be available in the main repo.
    var mimeType: String? {
        get { return objc_getAssociatedObject(self, &_imageFormatAK) as? String }
        set { objc_setAssociatedObject(self, &_imageFormatAK, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
