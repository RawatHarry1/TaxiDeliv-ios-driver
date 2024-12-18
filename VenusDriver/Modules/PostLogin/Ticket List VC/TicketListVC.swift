//
//  TicketListVM.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 10/12/24.
//

import UIKit

class TicketListVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    static func create() -> UIViewController {
        let obj = TicketListVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }
    
    var objRaiseTicketVM = RaiseTicketVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTicketListApi()
        tblView.rowHeight = 185
        getTicketListApi()
    }
    
   func getTicketListApi(){
       self.objRaiseTicketVM.getTicketList() {
          
           self.tblView.reloadData()
       }
    }

    @IBAction func btnBackAction(_ sender: Any) {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.showLeftView()
    }
    
    func convertUTCToLocalDate(utcDateString: String) -> String? {
        // Create a DateFormatter for the UTC format
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // Convert string to Date
        guard let date = utcDateFormatter.date(from: utcDateString) else {
            print("Invalid date string")
            return nil
        }
        
        // Create another DateFormatter for the local format
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateFormat = "hh:mm a | dd/MM/yyyy" // Customize as needed
        localDateFormatter.timeZone = TimeZone.current // Local timezone
        
        // Convert Date to local string
        let localDateString = localDateFormatter.string(from: date)
        return localDateString
    }
}

extension TicketListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objRaiseTicketVM.objTicketListModal?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTblCell", for: indexPath) as! TicketTblCell
        cell.mainView.addShadowView()
        let obj = self.objRaiseTicketVM.objTicketListModal?.data?[indexPath.row]
        if let localDate = convertUTCToLocalDate(utcDateString: obj?.created_at ?? "") {
            cell.lblDate.text = localDate
        }
       
        cell.lblReason.text = obj?.subject ?? ""
        cell.ticketId.text = "\(obj?.id ?? 0)"
        if obj?.status == 0{
            cell.lblStatus.text = "Sent"
        }else if obj?.status == 1{
            cell.lblStatus.text = "In Queue"
        }else{
            cell.lblStatus.text = "Resolved"
        }
        return cell
    }
    
    
}
