//
//  CoinData.swift
//  ByteCoins
//
//  Created by Александр Христиченко on 22.05.2022.
//

import Foundation

struct CoinData: Codable {
    let rate: Double
    let asset_id_quote: String
    let time: String
    let asset_id_base: String
}
