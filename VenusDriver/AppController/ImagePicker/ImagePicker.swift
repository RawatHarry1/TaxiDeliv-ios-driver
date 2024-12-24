//
//  ImagePicker.swift
//  VenusDriver
//
//  Created by Amit on 23/07/23.
//

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

enum UploadFileFor {
    case novalue
    case profile
}

protocol UploadFileAlertDelegates: AnyObject {
    func didSelect(data: Data?, name: String?, type: UploadFileFor)
//    func didUploadFile(data: [String:Any]?)
}

class UploadFileAlert: NSObject {

    //MARK: Variables
    static let sharedInstance = UploadFileAlert()
    private var presentedOnVC: UIViewController!
    private var picker:UIImagePickerController!
    var delegate: UploadFileAlertDelegates?
    private var currentType: UploadFileFor?

    //MARK: Custom methods
    public func alert(_ vc: UIViewController , _ filefor: UploadFileFor, _ showPDF: Bool = true , _ imgDelegate: UploadFileAlertDelegates){
        presentedOnVC = vc
        currentType = filefor
        delegate = imgDelegate
        let alertController = UIAlertController(title: "", message: "Select File to upload", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { alert in
            self.showCamera()
        }))

        alertController.addAction(UIAlertAction(title: "Photos", style: .default, handler: { alert in
            self.showPhotoLibrary()
        }))

        if showPDF{
            alertController.addAction(UIAlertAction(title: "PDF", style: UIAlertAction.Style.default, handler: { alert in
                self.selectPDF()
            }))
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { alert in

        }))

        vc.present(alertController, animated: true, completion: nil)

    }


    private func showCamera()  {
        picker = UIImagePickerController()
        picker.view.backgroundColor = UIColor.white
        picker.sourceType = UIImagePickerController.SourceType.camera
        picker.delegate = self
        picker.allowsEditing = true
        picker.modalPresentationStyle = .overFullScreen
        presentedOnVC.present(picker, animated: true, completion: nil)
    }

    private func showPhotoLibrary()  {
        picker = UIImagePickerController()
        picker.view.backgroundColor = UIColor.white
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        picker.modalPresentationStyle = .overFullScreen
        presentedOnVC.present(picker, animated: true, completion: nil)
    }

    private func selectPDF(){
        if #available(iOS 14.0, *) {
            let supportedTypes: [UTType] = [UTType.pdf]
            let importMenu = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .overFullScreen
            UINavigationBar.appearance(whenContainedInInstancesOf: [UIDocumentBrowserViewController.self]).tintColor = nil
            presentedOnVC.present(importMenu, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
}


//MARK: UIIMagePickerDelegates
extension UploadFileAlert: UIImagePickerControllerDelegate ,  UINavigationControllerDelegate, UIDocumentPickerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let imgData = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage)?.jpegData(compressionQuality: 0.5)
        let imgDataInMB : Double = ((Double(imgData?.count ?? 0))/1024.0)/1024.0

//        printLn(imgDataInMB/1024.0/1024.0)

        if imgDataInMB > 5.0 {
            picker.dismiss(animated: true, completion: nil)
             return
        }

        var finalName = ""
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let name = imageURL.deletingPathExtension().lastPathComponent
            finalName = name + "." + imageURL.pathExtension
        }
        else{
            let timestamp = Date().timeIntervalSince1970
            finalName = "\(timestamp)" + ".png"
        }
        delegate?.didSelect(data: imgData, name: finalName, type: currentType ?? .novalue)
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)

    }

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        printDebug("import result : \(myURL)")
    }
}


//MARK: API's
extension UploadFileAlert{


}

