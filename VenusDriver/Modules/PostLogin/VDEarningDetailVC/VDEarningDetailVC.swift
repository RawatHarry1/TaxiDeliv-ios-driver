//
//  VDEarningDetailVC.swift
//  VenusDriver
//
//  Created by Amit on 19/06/23.
//

import UIKit

class VDEarningDetailVC: VDBaseVC, CollectionViewCellDelegate {
    func didSelectItem(url: String) {
        // Navigate to a new view controller
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewerVC") as! ImageViewerVC
        detailVC.url = url
        detailVC.modalPresentationStyle = .overFullScreen
        self.present(detailVC, animated: true)
    }
    

    // MARK: - Outlets
    @IBOutlet weak var btnDownloadInvoiceOutlet: UIButton!
    
    @IBOutlet weak var lblCommission: UILabel!
    @IBOutlet weak var lblVAT: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var rideImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var recievedAmountLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var rideFareLbl: UILabel!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var waitingTimeLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var heightTblView: NSLayoutConstraint!
    @IBOutlet var stackViewParent: UIStackView!
    var viewModel: VDEarningDetailViewModel = VDEarningDetailViewModel()
    var tripID: Int?
    var rideStarus = ""
    
    //  To create ViewModel
    static func create() -> VDEarningDetailVC {
        let obj = VDEarningDetailVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }
    var delivery_packages: [DeliveryPackageHistoryData]?

    override func initialSetup() {
        
        if self.rideStarus == "Ride Cancelled"{
            self.btnDownloadInvoiceOutlet.isHidden = true
        }else{
            self.btnDownloadInvoiceOutlet.isHidden = false
        }
        
        
        if let tripID = tripID {
            let attributes = ["tripId" : tripID]
            viewModel.fetchBookingHistory(attributes)
        } else { 
            printDebug("======tripID not found===========")
        }

        viewModel.bookingHistorysuccessCallBack = { details in
            printDebug(details)
            self.nameLbl.text = details.customer_name
            if let currency = UserModel.currentUser.login?.currency_symbol {
                self.recievedAmountLbl.text = "Your Received Amount  \(currency) " + (details.total_fare ?? 0.0).toString
            } else {
                self.recievedAmountLbl.text = "Your Received Amount  $ " + (details.total_fare ?? 0.0).toString
            }
            if let currency = UserModel.currentUser.login?.currency_symbol {
                self.lblVAT.text = currency + " " + (details.net_customer_tax ?? 0.0).toString
                self.lblCommission.text = currency + " " + (details.venus_commission ?? 0.0).toString
                self.rideFareLbl.text = currency + " " + (details.ride_fare ?? 0.0).toString
                self.subtotalLbl.text = currency + " " + (details.sub_total_ride_fare ?? 0.0).toString
                
            } else {
                self.rideFareLbl.text = "$ " + (details.ride_fare ?? 0.0).toString
                self.subtotalLbl.text = "$ " + (details.sub_total_ride_fare ?? 0.0).toString
            }
            self.rideImgView.setImage(withUrl: details.tracking_image ?? "") { status, image in}
            self.waitingTimeLbl.text = "\((details.wait_time ?? 0)) mins"
            self.dateLbl.text = ConvertDateFormaterRideDetail(date: details.created_at ?? "")
            self.stackViewParent.isHidden = true
            if details.delivery_packages?.count ?? 0 > 0
            {
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.delivery_packages = details.delivery_packages
                self.stackViewParent.isHidden = false
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
                
                
            }
           
           

//            if let date = details.arrived_at?.toDate(dateFormat: DateFormatter.updatedisoFormat) {
//                printDebug(date)
//                self.dateLbl.text = date.toDateTimeString(dateFormat: "dd/MMM/yyyy • hh:mm a")
//            }
//            printDebug(details.arrived_at?.toDate(dateFormat: <#T##String#>))
            
          
        }
    }
    
    @IBOutlet var lblPackageSize: UILabel!
    @IBOutlet var btnArrow: UIImageView!
    @IBOutlet var stackMainView: UIStackView!
    @IBOutlet var lblPackageType: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBAction func btnShowHideStackView(_ sender: UIButton) {
        tblView.isHidden = tblView.isHidden == true ? false : true
        btnArrow.image = tblView.isHidden == true ? UIImage(named: "upArrow") : UIImage(named: "arrowDown2")
    }
    @IBAction func btnRaiseATicket(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RaiseTicketVC") as! RaiseTicketVC
        vc.rideId = "\(tripID ?? 0)"
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
       // self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func btnDownloadInvoice(_ sender: Any) {
        let pdfUrlString = "\(sharedAppDelegate.appEnvironment.baseURL)/ride/invoice?ride_id=\(self.tripID ?? 0)"
             if let pdfUrl = URL(string: pdfUrlString) {
                 if #available(iOS 14.0, *) {
                     downloadPDF(from: pdfUrl)
                 } else {
                     // Fallback on earlier versions
                 }
             }
    }
    
    @IBAction func sideMenuBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
        //self.navigationController?.popViewController(animated: true)
    }
}
extension VDEarningDetailVC: UIDocumentPickerDelegate {
    @available(iOS 14.0, *)
    func downloadPDF(from url: URL) {
        let urlSession = URLSession.shared
        let downloadTask = urlSession.downloadTask(with: url) { (location, response, error) in
            guard let location = location, error == nil else {
                print("Error downloading PDF: \(String(describing: error?.localizedDescription))")
                return
            }
            
            do {
                let temporaryDirectoryURL = FileManager.default.temporaryDirectory
                let temporaryPdfUrl = temporaryDirectoryURL.appendingPathComponent("downloadedInvoice.pdf")
                
                // Remove existing file if it exists
                if FileManager.default.fileExists(atPath: temporaryPdfUrl.path) {
                    try FileManager.default.removeItem(at: temporaryPdfUrl)
                }
                
                // Move the downloaded file to the temporary location
                try FileManager.default.moveItem(at: location, to: temporaryPdfUrl)
                print("PDF downloaded and saved to: \(temporaryPdfUrl)")
                
                DispatchQueue.main.async {
                    self.saveToiCloudDrive(fileUrl: temporaryPdfUrl)
                }
                
            } catch {
                print("Error saving PDF: \(error.localizedDescription)")
            }
        }
        downloadTask.resume()
    }
    
    @available(iOS 14.0, *)
    func saveToiCloudDrive(fileUrl: URL) {
        let documentPicker = UIDocumentPickerViewController(forExporting: [fileUrl])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
}

extension VDEarningDetailVC {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("Document saved to: \(urls.first?.path ?? "")")
        // Optionally, you can show an alert to inform the user that the document was saved successfully
        let alertController = UIAlertController(title: "Success", message: "PDF has been saved to iCloud Drive.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("User cancelled the document picker")
    }
}

extension VDEarningDetailVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delivery_packages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "PackageThreeCell", bundle: nil), forCellReuseIdentifier: "PackageThreeCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageThreeCell", for: indexPath) as! PackageThreeCell
        let obj = self.delivery_packages?[indexPath.row]
        cell.lblSize.text = obj?.package_size ?? ""
        cell.lblPackageType.text = obj?.package_type ?? ""
        cell.delegate = self
        cell.lblQuantity.text = String(describing: obj?.package_quantity ?? 0)
        cell.objDelivery_packages = obj
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        if  (obj?.package_image_while_pickup?.count ?? 0) == 0{
            cell.pickUpImagesStack.isHidden = true
            cell.lblPickedUpSeperator.isHidden = true
        }
        else
        {
            cell.pickUpImagesStack.isHidden = false
            cell.lblPickedUpSeperator.isHidden = false

        }
        if  (obj?.package_image_while_drop_off?.count ?? 0) == 0 && (obj?.package_image_while_pickup?.count ?? 0) == 0{
            cell.lblDeliveredSeparator.isHidden = true
            cell.lblDeliveredIImages.isHidden = true
            cell.deliveredImageView.isHidden = true
            cell.heightCell.constant = 300
            
        }
        else if (obj?.package_image_while_drop_off?.count ?? 0) == 0
        {
            cell.lblDeliveredSeparator.isHidden = true
            cell.lblDeliveredIImages.isHidden = true
            cell.deliveredImageView.isHidden = true
            cell.heightCell.constant = 420
        }
        else
        {
            cell.lblDeliveredSeparator.isHidden = false
            cell.lblDeliveredIImages.isHidden = false
            cell.deliveredImageView.isHidden = false
            cell.heightCell.constant = 536
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            
            self.heightTblView.constant = self.tblView.contentSize.height
            self.tblView.isHidden = self.tblView.numberOfRows(inSection: 0) == 0 ? true : false
        }
    }
}


