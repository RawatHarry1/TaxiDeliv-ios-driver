//
//  VDEarningVC.swift
//  VenusDriver
//
//  Created by Amit on 19/06/23.
//

import UIKit

class VDEarningVC: VDBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var earningTableView: UITableView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var labelMyEarning: UILabel!
    @IBOutlet weak var earningView: UIView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var hideFilterBtn: UIButton!
    @IBOutlet weak var filterOptionsView: UIView!
    @IBOutlet weak var earningTabBtn: UIButton!
    @IBOutlet weak var bookingsTabBtn: UIButton!
    @IBOutlet weak var totalEarningLbl: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!

    @IBOutlet weak var lblEarningType: UILabel!
    // MARK: -> Variable
    var screenType = 0
    var earningViewModel: VDEarningViewModel = VDEarningViewModel()

    //  To create ViewModel
    static func create(_ type: Int) -> UIViewController {
        let obj = VDEarningVC.instantiate(fromAppStoryboard: .postLogin)
        obj.screenType = type
        return obj
    }

    override func initialSetup() {
        earningTableView.delegate = self
        earningTableView.dataSource = self
        earningTableView.register(UINib(nibName: "VDBookingCell", bundle: nil), forCellReuseIdentifier: "VDBookingCell")
        earningTableView.register(UINib(nibName: "VDEarningCell", bundle: nil), forCellReuseIdentifier: "VDEarningCell")
        filterOptionsView.addShadowView()
        earningViewModel.bookingHistorysuccessCallBack = { bookings in
            self.earningTableView.reloadData()
        }

        earningViewModel.earningHistorysuccessCallBack = { earnings in
            self.earningTableView.reloadData()
            if let currency = UserModel.currentUser.login?.currency_symbol {
                self.totalEarningLbl.text = currency + " " + (earnings.totalEarnings?.toString ?? "0")
            } else {
                self.totalEarningLbl.text = "$ " + (earnings.totalEarnings?.toString ?? "0")
            }
        }

        if (screenType == 1) {
            bookingViewSelected()
        } else {
            earnningViewSelected()
        }
        pickerView.delegate = self
    }
    var pickerOptions = ["All", "Daily", "Weekly"]
    var pickerOptionsOnOff = ["All", "Cash", "Online"]
    var selectedOptionEarn: String?
    var selectedOptionPayment: String?
    var selectedPickerEarn = true

    func earnningViewSelected() {
        filterView.isHidden = false
        earningTableView.borderWidth = 1
        earningView.isHidden = false
        earningTabBtn.backgroundColor = VDColors.buttonSelectedOrange.color
        earningTabBtn.setTitleColor(VDColors.textColorWhite.color, for: .normal)
        bookingsTabBtn.backgroundColor = VDColors.textColorWhite.color
        bookingsTabBtn.setTitleColor(VDColors.buttonSelectedOrange.color, for: .normal)
        labelMyEarning.text = "My Earnings"
        earningViewModel.fetchEarningList()
    }

    func bookingViewSelected() {
        filterView.isHidden = true
        earningTableView.borderWidth = 0
        earningView.isHidden = true
        bookingsTabBtn.backgroundColor = VDColors.buttonSelectedOrange.color
        bookingsTabBtn.setTitleColor(VDColors.textColorWhite.color, for: .normal)
        earningTabBtn.backgroundColor = VDColors.textColorWhite.color
        earningTabBtn.setTitleColor(VDColors.buttonSelectedOrange.color, for: .normal)
        labelMyEarning.text = "My Bookings"
        earningViewModel.fetchBookingHistory()
    }

    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBAction func btnEarningType(_ sender: Any) {
        self.selectedPickerEarn = true
        self.pickerView.reloadAllComponents()
        self.viewPicker.isHidden = false
        
    }
    @IBAction func btnSideMenu(_ sender: UIButton) {
        guard let sideMenu = sideMenuController else { return }
        sideMenu.showLeftView()
    }

    @IBAction func pickerDone(_ sender: UIButton) {
        self.viewPicker.isHidden = true
        let row = pickerView.selectedRow(inComponent: 0)
        if selectedPickerEarn == true
        {
            selectedOptionEarn = pickerOptions[row]
            lblEarningType.text = selectedOptionEarn
            earningViewModel.fetchEarningList(filter: row)
        }
        else
        {
            selectedOptionPayment = pickerOptionsOnOff[row]
            lblPaymentMode.text = selectedOptionPayment
            earningViewModel.fetchEarningList(paymentMode: row)

        }
    }
    @IBAction func btnhideFilter(_ sender: UIButton) {
        filterOptionsView.isHidden = true
        hideFilterBtn.isHidden = true
    }

    @IBAction func btnFilter(_ sender: UIButton) {
        filterOptionsView.isHidden = false
        hideFilterBtn.isHidden = false
    }

    @IBAction func earningBtn(_ sender: UIButton) {
        screenType = 0
        earnningViewSelected()
        self.earningTableView.reloadData()
    }

    @IBAction func btnPaymentModel(_ sender: UIButton) {
        self.selectedPickerEarn = false
        self.pickerView.reloadAllComponents()
        self.viewPicker.isHidden = false
        
    }
    @IBAction func bookingsBrn(_ sender: UIButton) {
        screenType = 1
        bookingViewSelected()
        self.earningTableView.reloadData()
    }
}


extension VDEarningVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataLbl.isHidden = true
        if screenType == 1 {
            guard let bookingHistory = earningViewModel.bookingHistoryArr else { return 0 }
            if bookingHistory.count == 0 {
                noDataLbl.isHidden = false
            }
            return bookingHistory.count
        } else {
            guard let earningHistory = earningViewModel.earningHistoryDetails else { return 0 }
            if (earningHistory.rides?.count ?? 0) == 0 {
                noDataLbl.isHidden = false
            }
            return earningHistory.rides?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if screenType == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VDBookingCell", for: indexPath) as? VDBookingCell
            cell?.updateUI(earningViewModel.bookingHistoryArr[indexPath.row])
            cell?.lblStatus.text = earningViewModel.bookingHistoryArr[indexPath.row].status_string ?? ""
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VDEarningCell", for: indexPath) as? VDEarningCell
            if let ride = earningViewModel.earningHistoryDetails.rides {
                cell?.updateCellUI(ride[indexPath.row])
            }
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if screenType == 1 {
            let vc = VDEarningDetailVC.instantiate(fromAppStoryboard: .postLogin)
            vc.tripID = earningViewModel.bookingHistoryArr[indexPath.row].trip_id
            vc.rideStarus = earningViewModel.bookingHistoryArr[indexPath.row].status_string ?? ""
            self.present(vc, animated: true)
            //self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension VDEarningVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedPickerEarn == true ? pickerOptions.count : pickerOptionsOnOff.count    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectedPickerEarn == true ?  pickerOptions[row] : pickerOptionsOnOff[row]
    }
}
