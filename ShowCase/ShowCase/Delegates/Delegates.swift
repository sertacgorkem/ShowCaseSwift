//
//  Delegates.swift
//  ShowCase
//
//  Created by Sertac Gorkem on 6/1/20.
//

import Foundation

protocol DamageSketchDelegate : class
{
    func damageSketchSaved(_encodedData: String)
}


protocol reverseGeocodeDelagate : class
{
    func canceled()
    func reverseGeocodeAccepted(addrNum: String, direction: String, street: String, lat: String, long: String, streetOccuredOn: String, streetCross: String)
    func reverseGeocodeAddressAccepted(address: String)
}
