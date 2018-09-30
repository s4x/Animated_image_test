//
//  GiphyService.swift
//  Animated image
//
//  Created by Serge Nanaev on 29/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

import Foundation

import GiphyCoreSDK

class GiphyService {
    let client = GPHClient(apiKey: "inser your key")

    func load(completion: @escaping (([GPHMedia]?) -> Void)) {
        client.search("omg", limit: 300) { (response, error) in
            DispatchQueue.main.async {
                completion(response?.data)
            }
        }
    }
}
