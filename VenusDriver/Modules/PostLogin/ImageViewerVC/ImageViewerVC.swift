//
//  ImageViewerVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 30/11/24.
//

import UIKit

class ImageViewerVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgView.setImage(url)
    }
    
    @IBAction func btnImageAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
