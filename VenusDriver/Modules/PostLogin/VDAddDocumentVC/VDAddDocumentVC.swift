//
//  VDAddDocumentVC.swift
//  VenusDriver
//
//  Created by Amit on 20/06/23.
//

import UIKit

class VDAddDocumentVC: VDBaseVC {

    
    @IBOutlet weak var labelDocTitle: UILabel!
    
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var frontDocImg: UIImageView!

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backDocImg: UIImageView!

    @IBOutlet weak var nextBtn: VDButton!

    @IBOutlet weak var frontLbl: UILabel!
    @IBOutlet weak var backLbl: UILabel!

    var screenType = 0
    var data_img: Data?
    var name_img:String?
    var selectedImage: UIImage?
    var imgTypeSelected = 0 // 0 for front, 1 for back
    var refreshScreen : (()-> (Void))?
    var documentDetail: DocumentDetails?
    var documentList: DocumentList?
    var comesFromPostLogin = false
    var viewModel: VDUploadDocumentViewModel = VDUploadDocumentViewModel()

    //  To create ViewModel
    static func create(_ type: Int = 0) -> VDAddDocumentVC {
        let obj = VDAddDocumentVC.instantiate(fromAppStoryboard: .documents)
        obj.screenType = type
        return obj
    }

    override func initialSetup() {
        if let doc = documentDetail {
            labelDocTitle.text = doc.doc_type_text ?? ""
            frontLbl.text = doc.image_position?[0].name ?? ""
            if (doc.image_position?.count ?? 0) == 1 {
                backView.isHidden = true
            } else {
                backLbl.text = doc.image_position?[1].name ?? ""
                backView.isHidden = false
            }
        }
    }

    @IBAction func btnNext(_ sender: UIButton) {
//        if screenType != 0 {
//            self.navigationController?.pushViewController(VDElectricVC.create(), animated: true)
//        } else {
        if comesFromPostLogin == true{
            self.dismiss(animated: true) {
                self.refreshScreen!()
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
           
//        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        if comesFromPostLogin == true{
            self.dismiss(animated: true) {
                self.refreshScreen!()
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func btnFrontDoc(_ sender: Any) {
        imgTypeSelected = 0
        UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
    }

    @IBAction func btnBackDoc(_ sender: UIButton) {
        imgTypeSelected = 1
        UploadFileAlert.sharedInstance.alert(self, .profile , false, self)
    }
}


//MARK: UploadFileAlertDelegates
extension VDAddDocumentVC: UploadFileAlertDelegates {
    func didSelect(data: Data?, name: String?, type: UploadFileFor) {
        if let dt = data{
            self.selectedImage = UIImage(data: dt)
            if imgTypeSelected == 0 {
                frontDocImg.image = UIImage(data: dt)
            } else {
                backDocImg.image = UIImage(data: dt)
            }

            self.data_img = data
            self.name_img = name

            if let doc = documentDetail {
                var attributes = [String:Any]()
                if (doc.image_position?.count ?? 0) > 0 {
                    attributes["imgPosition"] = (imgTypeSelected == 0) ? (doc.image_position?[0].img_position) : (doc.image_position?[1].img_position)
                } else {
                    attributes["imgPosition"] = doc.image_position?[0].img_position
                }
                attributes["docTypeNum"] = doc.doc_type_num
                self.viewModel.uploadDocument(attributes, self.selectedImage!)
            }
        }
    }
}
