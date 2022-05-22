//
//  CoinManager.swift
//  ByteCoins
//
//  Created by Александр Христиченко on 22.05.2022.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "0EF080C8-5188-497D-B264-EE93AE1E0547"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        //print(urlString)
        
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return //stop if there is an error
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(currencyData: safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                        //print(priceString)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(currencyData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(CoinData.self, from: currencyData)
           let lastPrice = decodedData.rate
            //print(lastPrice)
           return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
