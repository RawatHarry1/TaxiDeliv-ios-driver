//
//  VDDocumentsCell.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import UIKit

class VDUploadDocumentsCell: UITableViewCell {

    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var btnUpload: VDButton!
    
    @IBOutlet weak var warningIcon: UIImageView!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var warningSV: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUI(_ doc : DocumentDetails){
        var docName = doc.doc_type_text ?? ""
        if doc.doc_requirement == 0 {
            docName += " (optional)"
        }
        titlelabel.text = docName
        warningSV.isHidden = true
        if doc.doc_status == DocumentStatus.pending.rawValue || doc.doc_status == DocumentStatus.uploaded.rawValue {
            btnUpload.setTitle("Document Uploaded", for: .normal)
            
        } else if doc.doc_status == DocumentStatus.rejected.rawValue {
            btnUpload.setTitle("Upload", for: .normal)
            warningSV.isHidden = false
            warningLbl.text = "Rejected"
            warningIcon.image = VDImageAsset.alertIcon.asset
        } else if  doc.doc_status == DocumentStatus.expired.rawValue {
            btnUpload.setTitle("Upload", for: .normal)
            warningLbl.text = "Expired"
            warningSV.isHidden = false
            warningIcon.image = VDImageAsset.warningIcon.asset
        } else if doc.doc_status == DocumentStatus.approved.rawValue {
            btnUpload.setTitle("Document Approved", for: .normal)
        } else  {
            btnUpload.setTitle("Upload", for: .normal)
        }
        self.layoutIfNeeded()
    }
}
