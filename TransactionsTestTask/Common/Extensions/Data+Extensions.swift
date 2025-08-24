//
//  Data+Extensions.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted, .sortedKeys, .fragmentsAllowed, .withoutEscapingSlashes]
              ),
              let prettyJSON = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue
              ) else {
            return nil
        }
        
        return prettyJSON
    }
    
    func decoded<T: Decodable>(
        as type: T.Type = T.self,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> T? {
        return try? decoder.decode(T.self, from: self)
    }
}
