//
//  CountryCodeVC.swift
//  LiveChat
//
//  Created by Amit on 11/03/22.
//

import UIKit

class CountryCodeVC: VDBaseVC {

    //MARK: Outlets
    @IBOutlet weak var tbl_country_list: UITableView!
    @IBOutlet weak var searchbar_list: UISearchBar!
        
    //MARK: Variables
    var country_list = [Country_Detail]()
    var filtered_list = [Country_Detail]()
    
    var countryCodeSelected:((Country_Detail)-> Void)?

    //  To create ViewModel
    static func create() -> CountryCodeVC {
        let obj = CountryCodeVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        onViewDidLoad()
    }

    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}

//MARK: Custom methods
extension CountryCodeVC{
    func onViewDidLoad(){
        country_list = CountryList
        filtered_list = country_list
        tbl_country_list.register(CountryDetailCell.nib, forCellReuseIdentifier: CountryDetailCell.identifier)
    }
}

//MARK: IBActions
extension CountryCodeVC {

}

//MARK: TableViewDelegates
extension CountryCodeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryDetailCell.identifier, for: indexPath) as! CountryDetailCell
        cell.updateCell(filtered_list[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = filtered_list[indexPath.row]
        self.dismiss(animated: true) {
            self.countryCodeSelected?(country)
        }
    }
    
}

//MARK: TableViewDataSources
extension CountryCodeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: UISearchBarDelegates
extension CountryCodeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            filtered_list = country_list
        }
        else{
            filtered_list = country_list.filter({ obj in
                if (obj.name ?? "").lowercased().contains(searchText.lowercased()) || (obj.dialcode ?? "").lowercased().contains(searchText.lowercased()){
                    return true
                }
                else{
                    return false
                }
            })
        }
        tbl_country_list.reloadData()
    }
}

