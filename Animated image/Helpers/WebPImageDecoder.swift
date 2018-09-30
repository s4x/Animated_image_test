//
//  WebPImageDecoder.swift
//  Animated image
//
//  Created by Serge Nanaev on 29/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

import Nuke
import YYImage

public class WebPImageDecoder: Nuke.ImageDecoding {

    private lazy var decoder: YYImageDecoder = YYImageDecoder()

    public init() {
    }

    public func decode(data: Data, isFinal: Bool) -> Image? {
        guard data.isWebPFormat, isFinal else { return nil }
        decoder.updateData(data, final: isFinal)

        let image = Image()
        image.animatedImageData = decoder.data

        return image
    }

}

// MARK: - check webp format data.
extension WebPImageDecoder {

    public static func enable() {
        Nuke.ImageDecoderRegistry.shared.register { (context) -> ImageDecoding? in
            WebPImageDecoder.enable(context: context)
        }
    }

    public static func enable(context: Nuke.ImageDecodingContext) -> Nuke.ImageDecoding? {
        return context.data.isWebPFormat ? WebPImageDecoder() : nil
    }

}

// MARK: - private
private let _queue = DispatchQueue(label: "Nuke-WebP-Plugin.DataDecoder")
extension WebPImageDecoder {

    internal func _decode(_ data: Data) -> Image? {
        return _queue.sync {
            decoder.updateData(data, final: false)
            return decoder.frame(at: 0, decodeForDisplay: true)?.image
        }
    }

}


private let fileHeaderIndex: Int = 12
private let fileHeaderPrefix = "RIFF"
private let fileHeaderSuffix = "WEBP"

// MARK: - WebP Format Testing
extension Data {

    internal var isWebPFormat: Bool {
        guard fileHeaderIndex < count else { return false }
        let endIndex = index(startIndex, offsetBy: fileHeaderIndex)
        let data = subdata(in: startIndex..<endIndex)
        let string = String(data: data, encoding: .ascii) ?? ""
        return string.hasPrefix(fileHeaderPrefix) && string.hasSuffix(fileHeaderSuffix)
    }

}
