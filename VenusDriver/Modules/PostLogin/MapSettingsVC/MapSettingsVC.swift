//
//  MapSettingsVC.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 11/12/24.
//

import UIKit

class MapSettingsVC: UIViewController {

    @IBOutlet weak var viewTraffic: UIView!
    @IBOutlet weak var viewdefaultMapDetail: UIView!
    @IBOutlet weak var viewTerrain: UIView!
    @IBOutlet weak var viewSetalite: UIView!
    @IBOutlet weak var viewDefault: UIView!
    
    var didSelectMapType : ((Int)-> Void)?
    var didSelectMapDetail : ((Int)-> Void)?
    var mapTypeVal = 0
    var mapDetailval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSelectedMap()
       
    }
    
    func checkSelectedMap(){
        if mapTypeVal == 1{
            selectedView(vw: viewSetalite)
            unSelectedView(vw: viewDefault)
            unSelectedView(vw: viewTerrain)
        }else if mapTypeVal == 2{
            selectedView(vw: viewTerrain)
            unSelectedView(vw: viewDefault)
            unSelectedView(vw: viewSetalite)
        }else{
            selectedView(vw: viewDefault)
            unSelectedView(vw: viewSetalite)
            unSelectedView(vw: viewTerrain)
        }
        
        if mapDetailval == 1{
          
            selectedView(vw: viewTraffic)
            unSelectedView(vw: viewdefaultMapDetail)
        }else{
          
            selectedView(vw: viewdefaultMapDetail)
            unSelectedView(vw: viewTraffic)
        }
    }
    
    
    func selectedView(vw: UIView){
        vw.layer.borderColor = UIColor(named: "buttonSelectedOrange")?.cgColor
        vw.layer.borderWidth = 2
    }
    
    func unSelectedView(vw: UIView){
        vw.layer.borderColor = UIColor.clear.cgColor
        vw.layer.borderWidth = 0
    }
    

    @IBAction func btnDefaultAction(_ sender: Any) {
        mapTypeVal = 0
        selectedView(vw: viewDefault)
        unSelectedView(vw: viewSetalite)
        unSelectedView(vw: viewTerrain)
        VDUserDefaults.save(value: 0, forKey: .mapType)
    }
    
    @IBAction func btnSetaliteAction(_ sender: Any) {
        mapTypeVal = 1
        selectedView(vw: viewSetalite)
        unSelectedView(vw: viewDefault)
        unSelectedView(vw: viewTerrain)
        VDUserDefaults.save(value: 1, forKey: .mapType)
    }
    
    @IBAction func btnTerrainAction(_ sender: Any) {
        mapTypeVal = 2
        selectedView(vw: viewTerrain)
        unSelectedView(vw: viewDefault)
        unSelectedView(vw: viewSetalite)
        VDUserDefaults.save(value: 2, forKey: .mapType)
    }
    
    @IBAction func btnDefaultMapDetailAction(_ sender: Any) {
        mapDetailval = 0
        selectedView(vw: viewdefaultMapDetail)
        unSelectedView(vw: viewTraffic)
        VDUserDefaults.save(value: 0, forKey: .mapDetail)
      
    }
    
    @IBAction func btnTrafficAction(_ sender: Any) {
        mapDetailval = 1
        selectedView(vw: viewTraffic)
        unSelectedView(vw: viewdefaultMapDetail)
        VDUserDefaults.save(value: 1, forKey: .mapDetail)
    }
    
    @IBAction func btnSetAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.didSelectMapType!(self.mapTypeVal)
            self.didSelectMapDetail!(self.mapDetailval)
        }
    }
    
    @IBAction func btnDismissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
