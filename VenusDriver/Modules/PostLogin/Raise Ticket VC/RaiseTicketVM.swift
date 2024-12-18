//
//  RaiseTicketVM.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 10/12/24.
//

import UIKit

struct TicketModal: Codable{
    var flag: Int?
    var message: String?
}
class RaiseTicketVM {

    var objTicketModal: TicketModal?
    var objTicketListModal : TicketListModal?
    
    
    func raiseTicket(rideID: String,subject: String,ticket_image: String,description: String,completion:@escaping() -> Void) {
        var params : JSONDictionary  {
            var attribute = [String : Any]()
            attribute["ride_id"] = rideID
            attribute["subject"] = subject
            attribute["ticket_image"] = ticket_image
            attribute["description"] = description
            return attribute
        }
        WebServices.raiseTicketApi(parameters: params) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let ticket = data as? TicketModal else {return}
                self?.objTicketModal = ticket
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    
    func getTicketList(completion:@escaping() -> Void) {
        var attributes : JSONDictionary {
            let att = [String:Any]()
            
            return att
        }
        WebServices.getTicketList( url: "", parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let dataModel = data as? TicketListModal else { return }
                print(dataModel)
                self?.objTicketListModal = dataModel
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

}
