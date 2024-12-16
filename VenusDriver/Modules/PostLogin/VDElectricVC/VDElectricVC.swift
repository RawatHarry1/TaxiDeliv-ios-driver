












//
//  VDElectricVC.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import UIKit

class VDElectricVC: VDBaseVC, UITextFieldDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var vehicleYearTF: SkyfieldTF!
    @IBOutlet weak var vehicleModelTF: SkyfieldTF!
    @IBOutlet weak var vehicleColorTF: SkyfieldTF!
    @IBOutlet weak var vehicleNumberTF: SkyfieldTF!
    @IBOutlet weak var vehicleTypeTF: SkyfieldTF!
    @IBOutlet weak var cityTF: SkyfieldTF!
    
    @IBOutlet weak var tblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listTop: NSLayoutConstraint!
    @IBOutlet weak var listBackBtn: UIButton!

    private var screenType = 0
    private var vehicleColorID: Int?
    private var vehicleModelID: Int?
    private var makeYear = ""
    private var selectedVehicleType: VehiclesType?
    private var vehicleModelList: [VehiclesModel]?
    private var selectedListtype:selectionTypeVehicleList = .colors //0 for colors, 1 for models, 2 for years // 3 for vehicle types
    private var selectedCity : City_list?
    private var cityList : [City_list]?

    var viewModel = VDElectricViewModel()
    var selectedIndex = 0
    var filteredCityList: [City_list] = []
    var selectedID = 0
    
    //  To create ViewModel
    static func create(_ type: Int = 0) -> UIViewController {
        let obj = VDElectricVC.instantiate(fromAppStoryboard: .postLogin)
        obj.screenType = type
        return obj
    }

    override func initialSetup() {
        
        if ClientModel.currentClientData.enabled_service! == 3{
            collectionView.isHidden = false
        }else if ClientModel.currentClientData.enabled_service! == 2{
            selectedID = 2
            collectionView.isHidden = true
        }else{
            selectedID = 1
            collectionView.isHidden = true
        }
        
        vehicleNumberTF.delegate = self
        listTableView.delegate  = self
        listTableView.dataSource = self
        if let cityId = UserModel.currentUser.login?.city {
            if let _cityList = ClientModel.currentClientData.city_list {
                self.cityList = _cityList
                let city = _cityList.filter({($0.city_id ?? 0) == cityId})
                if city.count > 0 {
                    self.selectedCity = city[0]
                    self.cityTF.text = self.selectedCity?.city_name ?? ""
                }
            }
            viewModel.fetchDocumentsList(cityId, rideType: self.selectedID, completion: {
                self.listTableView.reloadData()
            })

        }
        listTableView.register(UINib(nibName: "VDElectricListCell", bundle: nil), forCellReuseIdentifier: "VDElectricListCell")

        viewModel.successCallBack = { status in
            if self.screenType == 0 {
               self.navigationController?.pushViewController(VDDocumentVC.create(1) , animated: true)
            }
        }

        UserModel.currentUser.login?.registration_step_completed?.is_profile_completed = true

        // Show Error Alert
        self.viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                CustomAlertView.showAlertControllerWith(title: error.title ?? "", message: error.errorDescription, onVc: self, buttons: ["OK"], completion: nil)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        listView.addShadowView()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func selectCityBtn(_ sender: UIButton) {
        self.lblNoDataFound.isHidden = true
        self.view.endEditing(true)
        listView.isHidden = false
        listBackBtn.isHidden = false
        listTop.constant = -120
        selectedListtype = .cityList
        listTableView.reloadData()
    }
    
    @IBAction func listBackBtnAction(_ sender: UIButton) {
        listView.isHidden = true
        listBackBtn.isHidden = true
    }

    @IBAction func vehicleTypeBtn(_ sender: UIButton) {
        self.lblNoDataFound.isHidden = true
        guard let _ = selectedCity else {
            SKToast.show(withMessage: "Please select city first.")
            return
        }
        self.view.endEditing(true)
        listView.isHidden = false
        listBackBtn.isHidden = false
        listTop.constant = -60
        selectedListtype = .vehicleType
        listTableView.reloadData()
    }

    @IBAction func vehicleModelBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        if vehicleModelList?.count ?? 0 == 0{
            self.lblNoDataFound.isHidden = false
        }else{
            self.lblNoDataFound.isHidden = true
        }
        guard let _ = self.selectedVehicleType else {
            SKToast.show(withMessage: "Please select vehicle type first.")
            return
        }

        listView.isHidden = false
        listBackBtn.isHidden = false
        listTop.constant = 0
        selectedListtype = .models
        listTableView.reloadData()
    }

    @IBAction func vehicleColorsBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.lblNoDataFound.isHidden = true
        guard let _ = self.vehicleModelID else {
            SKToast.show(withMessage: "Please select vehicle model first.")
            return
        }

        listView.isHidden = false
        listBackBtn.isHidden = false
        listTop.constant = 60
        selectedListtype = .colors
        listTableView.reloadData()
    }

    @IBAction func btnVehicleYear(_ sender: UIButton) {
        self.lblNoDataFound.isHidden = true
        guard let _ = self.vehicleModelID else {
            SKToast.show(withMessage: "Please select vehicle model first.")
            return
        }

        self.view.endEditing(true)
        listView.isHidden = false
        listBackBtn.isHidden = false
        listTop.constant = 120
        selectedListtype = .years
        listTableView.reloadData()
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.validateAddVehicleDetails((makeYear).trimmed, (vehicleNumberTF.text ?? "").trimmed, vehicleModelID, vehicleColorID, selectedCity?.city_id ?? 0,vehicleType: vehicleTypeTF.text ?? "", request_ride_type: self.selectedID)

//        if screenType == 0 {
//            self.navigationController?.pushViewController(VDPayoutInfoVC.create() , animated: true)
//        }
    }
    
    
}

extension VDElectricVC: UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedListtype == .years {
            return years.count
        }
        if selectedListtype == .cityList {
            return filteredCityList.count
        }
        if let list = viewModel.vehicleFeatures {
          
            if selectedListtype == .vehicleType { return list.vehicle_type?.count ?? 0}

            return (selectedListtype == .colors) ? (list.colors?.count ?? 0) : (vehicleModelList?.count ?? 0)
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDElectricListCell", for: indexPath) as! VDElectricListCell
        if selectedListtype == .years {
            cell.setUpdateYearUI(years[indexPath.row])
        } else if selectedListtype == .vehicleType {
            if let list = viewModel.vehicleFeatures.vehicle_type {
                cell.setUpVehicleTypeUI(list[indexPath.row])
            }
        } else if selectedListtype == .colors {
            if let colors = viewModel.vehicleFeatures.colors {
                cell.setColorUI(colors[indexPath.row])
            }
        } else if selectedListtype == .cityList {
            let cityList = filteredCityList
            cell.setCityListUI(cityList[indexPath.row])
        } else {
            if let vehicles = vehicleModelList {
                cell.setModelUI(vehicles[indexPath.row])
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listView.isHidden = true
        listBackBtn.isHidden = true

        if selectedListtype == .colors {
            if let list = viewModel.vehicleFeatures {
                if (list.colors?.count ?? 0 > 0) {
                    vehicleColorID = list.colors![indexPath.row].id
                    vehicleColorTF.text = list.colors![indexPath.row].value
                }
            }
        } else if selectedListtype == .models {
            if let vehicles = vehicleModelList {
                if (vehicles.count > 0) {
                    vehicleModelID = vehicles[indexPath.row].id
                    vehicleModelTF.text = vehicles[indexPath.row].model_name
                }
            }
        } else if selectedListtype == .years {
            makeYear = years[indexPath.row]
            vehicleYearTF.text = years[indexPath.row]
        } else if selectedListtype == .vehicleType {
            if let vehicleType = viewModel.vehicleFeatures.vehicle_type {
                selectedVehicleType = vehicleType[indexPath.row]
                vehicleTypeTF.text = selectedVehicleType?.vehicle_type_name ?? ""
                vehicleModelList = viewModel.vehicleFeatures.vehicles?.filter({$0.vehicle_type == selectedVehicleType?.vehicle_type})
                vehicleModelID = nil
                vehicleModelTF.text = ""
            } else {
                printDebug("Vehicle type not found")
            }
        } else if selectedListtype == .cityList {
            self.selectedCity = self.cityList?[indexPath.row]
            self.viewModel.fetchDocumentsList(self.selectedCity?.city_id ?? 0, rideType: self.selectedID, completion: {
                self.listTableView.reloadData()
            })
            
            self.cityTF.text = self.selectedCity?.city_name ?? ""
            selectedVehicleType = nil
            vehicleTypeTF.text = ""
            vehicleModelID = nil
            vehicleModelTF.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if (textField.text?.count)! == 0 && string == " " {
            return false
        }
        
        // SignUp Page -> FullName, Email, , Password, ConfirmPassword
        if textField == vehicleNumberTF {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        // SignUp page -> Mobile field
       
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tblHeightConstant.constant = self.listTableView.contentSize.height
        }
    }
    
    func selectedCell(view:UIView){
        view.layer.borderColor = UIColor(named: "buttonSelectedOrange")?.cgColor
        view.layer.borderWidth = 1
    }
    
    func unSelectedCell(view:UIView){
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
    }
    
    func filterCities() {
        // Unwrap city_list safely using optional binding
        guard let cities = ClientModel.currentClientData.city_list else { return }
        
        // Filter cities where operator_available contains 1
        filteredCityList = cities.filter { city in
            // Check if operator_available contains 1
            if let operators = city.operator_available {
                return operators.contains(selectedID)
            }
            return false
        }

        // At this point, filteredCityList contains the filtered City_list objects
        print(filteredCityList) // You can reload your table view here if needed
    }
}
extension VDElectricVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ClientModel.currentClientData.operator_availablity?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionCell", for: indexPath) as! TypeCollectionCell
        let obj = ClientModel.currentClientData.operator_availablity?[indexPath.row]
        
        if collectionView.isHidden == false{
            if selectedIndex == indexPath.row{
                selectedID = obj?.id ?? 0
                self.viewModel.fetchDocumentsList(self.selectedCity?.city_id ?? 0, rideType: self.selectedID, completion: {
                    self.cityTF.text = ""
                    self.vehicleTypeTF.text = ""
                })
                filterCities()
                listTableView.reloadData()
                self.selectedCell(view: cell.viewBase)
            }else{
                self.unSelectedCell(view: cell.viewBase)
            }
        }
        
        
        cell.lblTitle.text = obj?.name ?? ""
        cell.imgViewIcon.setImage(withUrl: obj?.image ?? "") { status, image in}
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isHidden == false{
            self.selectedIndex = indexPath.row
            self.collectionView.reloadData()
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width / 2 - 5 , 50)
    }
    
}
