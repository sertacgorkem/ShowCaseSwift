//
//  Constants.swift
//  ShowCase
//
//  Created by Sertac Gorkem on 6/1/20.
//

import Foundation
import UIKit

struct SignLine: Codable {
    var start: CGPoint
    var end: CGPoint
    init(startX:Int, startY:Int, endX:Int, endY:Int) {
        start = CGPoint(x: startX, y: startY)
        end = CGPoint(x:endX, y: endY)
    }
    
    
}

var damageImageDictionary = [Int: String]()
func addDamageImageFiles(){
    damageImageDictionary = [Int:String]()
   
    damageImageDictionary[1] = "car1_sketch"
    damageImageDictionary[2] = "car2d_bp"
    damageImageDictionary[3] = "defaultDamage"
    damageImageDictionary[4] = "suv_bp"
    damageImageDictionary[5] = "minivan_bp"
    damageImageDictionary[6] = "truck_bp"
    damageImageDictionary[7] = "motorbike_sketch"
    damageImageDictionary[8] = "bicycle_sketch_bp"
    damageImageDictionary[9] = "truck_sketch"
    damageImageDictionary[10] = "freight_sketch"
}


