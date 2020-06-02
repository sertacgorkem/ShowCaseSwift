//
//  UtilityFunctions.swift
//  ShowCase
//
//  Created by Sertac Selim Gorkem on 6/1/20.
//  Copyright © 2020 Serta.co. All rights reserved.
//

import Foundation


func subString(mainString: String, startIndex: Int, endIndex: Int = 0) -> String? {
    var result : String = ""
    var endInd = endIndex
    if (endInd == 0) {
        endInd = mainString.count
    }
    
    if (endInd > mainString.count) {
        endInd = mainString.count
    }
    result = mainString[startIndex..<endInd]
 
    return result
}

func indexOf(stringField: String, _ input: String, options: String.CompareOptions = .literal) -> String.Index? {
    return stringField.range(of: input, options: options)?.lowerBound
}


func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func removeFrontAndLast(value: String) -> String {
      return String(value[value.index(value.startIndex, offsetBy: 1)..<value.index(value.endIndex, offsetBy: -1)])
}
      


extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
