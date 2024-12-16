//
//  CardsVM.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 05/08/24.
//

import Foundation

struct CardsModal:Codable{
    var flag: Int?
    var message: String?
    var data: CardsData?
    
}

struct CardsData: Codable{
    var client_secret: String?
    var setupIntent: setupIntent?
}

struct setupIntent:Codable{
    var id: String?
    var object: String?
    var client_secret: String?
}
