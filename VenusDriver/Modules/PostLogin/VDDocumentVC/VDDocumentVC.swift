//
//  VDDocumentVC.swift
//  VenusDriver
//
//  Created by Amit on 20/06/23.
//

import UIKit

class VDDocumentVC: VDBaseVC {

    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var documentTableView: UITableView!
    @IBOutlet weak var btnNext: VDButton!

    var documentsViewModel: VDDocumentViewModel = VDDocumentViewModel()

    var screenType = 0
    //  To create ViewModel
    static func create(_ type: Int = 0) -> UIViewController {
        let obj = VDDocumentVC.instantiate(fromAppStoryboard: .documents)
        obj.screenType = type
        return obj
    }

    override func initialSetup() {
        if screenType != 0 {
            btnSideMenu.setImage(VDImageAsset.backbutton.asset, for: .normal)
            btnSideMenu.isHidden = true
        } else {
            btnNext.isHidden = true
        }

        UserModel.currentUser.login?.registration_step_completed?.is_vehicle_info_completed = true

        documentTableView.delegate = self
        documentTableView.dataSource = self

        documentTableView.register(UINib(nibName: "VDUploadDocumentsCell", bundle: nil), forCellReuseIdentifier: "VDUploadDocumentsCell")

        documentsViewModel.updateDocumentList = { [weak self] list in
            if let modelList = self?.documentsViewModel.docuemntList {
                let pendingDocs = modelList.list?.filter({$0.doc_status == "NOT_UPLOADED" && $0.doc_requirement != 0})
                if (pendingDocs?.count ?? 0) > 0 {
//                    SKToast.show(withMessage: "Please upload all the documents to proceed.")
                } else {
                    let rejectedDocs = modelList.list?.filter({ ($0.doc_status == DocumentStatus.rejected.rawValue && $0.doc_requirement != 0) || ($0.doc_status == DocumentStatus.expired.rawValue && $0.doc_requirement != 0)})
                    
                    let uploadedDocs = modelList.list?.filter({$0.doc_status == DocumentStatus.uploaded.rawValue && $0.doc_requirement != 0})
                    
                    var currentUser = UserModel.currentUser
                    if rejectedDocs?.count == 0 && (uploadedDocs?.count ?? 0) > 0 {
                        currentUser.login!.driver_document_status?.requiredDocsStatus = DocumentStatus.pending.rawValue
                    } else if rejectedDocs?.count == 0 {
                        currentUser.login!.driver_document_status?.requiredDocsStatus = DocumentStatus.approved.rawValue
                    } else {
                        currentUser.login!.driver_document_status?.requiredDocsStatus = DocumentStatus.rejected.rawValue
                    }
                    UserModel.currentUser = currentUser
                }
            }

            self?.documentTableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        documentsViewModel.fetchDocumentsList()
        self.documentTableView.reloadData()
    }

    @IBAction func drivingLicenseBtn(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDAddDocumentVC.create(screenType), animated: true)
    }

    @IBAction func btnSideMenu(_ sender: UIButton) {
//        guard let sideMenu = sideMenuController else { return }
//        sideMenu.showLeftView()
        NotificationCenter.default.post(name: .openSideMenu, object: nil)
    }

    @IBAction func btnMunicipleCard(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDAddMunicipleCardVC.create(screenType), animated: true)
    }

    @IBAction func completeUploadBtn(_ sender: VDButton) {
        if let modelList = documentsViewModel.docuemntList {
            let pendingDocs = modelList.list?.filter({$0.doc_status == "NOT_UPLOADED" && $0.doc_requirement != 0})
            if (pendingDocs?.count ?? 0) > 0 {
                let alert = UIAlertController(title: "", message: "Please upload all the documents to proceed.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
              
            } else {
                if (screenType == 0) {
                } else {
                    self.navigationController?.pushViewController(VDPayoutInfoVC.create(), animated: true)
                }
            }
        }
    }
}

extension VDDocumentVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let modelList = documentsViewModel.docuemntList else {return 0}
        return modelList.list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDUploadDocumentsCell", for: indexPath) as! VDUploadDocumentsCell
        cell.btnUpload.tag = indexPath.row
        if let modelList = documentsViewModel.docuemntList {
            if let docDetail = modelList.list?[indexPath.row]  {
                cell.setUI(docDetail)
                self.view.layoutIfNeeded()
            }
        }
        cell.btnUpload.addTarget(self, action: #selector(uploadDocumentAction), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @objc func uploadDocumentAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Upload" {
            if let modelList = documentsViewModel.docuemntList {
                let selectedDoc = modelList.list?[sender.tag]
                let vc = VDAddDocumentVC.create(screenType)
                vc.modalPresentationStyle = .overFullScreen
                vc.documentDetail = selectedDoc
                vc.comesFromPostLogin = true
                vc.documentList = modelList
                vc.refreshScreen = {
                    self.documentsViewModel.fetchDocumentsList()
                    self.documentTableView.reloadData()
                }
                self.present(vc, animated: true)
                //self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            
        }
    }
}
