//
//  CardsVM.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 05/08/24.
//

import Foundation

class CardsVM{
    
    var objCardModal: CardsModal?
    var objGetCardModal: GetCardsModal?
    func addCard(clientSecret: String,completion:@escaping() -> Void) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["client_secret"] = clientSecret
            return attribute
        }
        WebServices.addCards(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let card = data as? CardsModal else {return}
                self?.objCardModal = card
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func deleteCard(cardID: String,completion:@escaping() -> Void) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["card_id"] = cardID
            return attribute
        }
        WebServices.deleteCard(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let card = data as? CardsModal else {return}
                self?.objCardModal = card
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func confirmCard(clientSecret: String,id:String,completion:@escaping() -> Void) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["client_secret"] = clientSecret
            attribute["setup_intent_id"] = id
            return attribute
        }
        WebServices.confirmCard(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let card = data as? CardsModal else {return}
                self?.objCardModal = card
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    func getCardApi(completion:@escaping() -> Void) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
          
            return attribute
        }
        WebServices.getCard(url: "", parameters: params, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let card = data as? GetCardsModal else {return}
                self?.objGetCardModal = card
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

}
