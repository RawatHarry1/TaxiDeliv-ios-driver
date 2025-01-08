//
//  VCFeedbackVC.swift
//  VenusCustomer
//
//  Created by Amit on 12/07/23.
//

import UIKit

class VCFeedbackVC: VCBaseVC {

    // MARK: -> Outlets
    @IBOutlet weak var feebackTV: UITextView!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starfour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var lblFare: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    
    var viewModel = FeedbackVM()
    var objEndTripModal: EndRideModel?
    var callBackRatingSuccess : ((Int) -> ())?
    var ratings = 3
    var viewcontrollerType = 1
    //  To create ViewModel
    static func create() -> VCFeedbackVC {
        let obj = VCFeedbackVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        feebackTV.textContainerInset = UIEdgeInsets.zero
        feebackTV.textContainer.lineFragmentPadding = 0

//        feebackTV.backgroundColor = UIColor.lightGray
//        feebackTV.textColor = VCColors.textColorGrey.color
//        feebackTV.text = "Share feedback with driver."
//        feebackTV.delegate = self
//        descLbl.text = "How was your ride with \(selectedTrip?.driver_name ?? "")"
        lblWallet.text = "\(objEndTripModal?.currency ?? "") \(objEndTripModal?.paid_using_wallet ?? 0)"
        lblFare.text = "\(objEndTripModal?.currency ?? "") \(objEndTripModal?.fare ?? 0)"
        titleLabelAttributes((objEndTripModal?.customer_name ?? ""))
        callBacks()
        ratingLbl.text = "Good"
    }

    private func callBacks() {
//        viewModel.successCallBack = { status in
//            self.dismiss(animated: true) {
//                if self.viewcontrollerType == 1 {
//                    self.callBackRatingSuccess?(self.ratings)
//                } else {
//                    VCRouter.goToSaveUserVC()
//                }
//            }
//        }
    }

    func titleLabelAttributes(_ clickAble: String) {
        let clickAble = clickAble
        let fullText = "How was your trip with \(clickAble)"
        let nsString = fullText as NSString
        let rangeClickableText = nsString.range(of: clickAble)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 24.0, weight: .semibold), range: rangeClickableText)
        descLbl.attributedText = attributedString
    }

    @IBAction func closeBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func starOneBtn(_ sender: UIButton) {
        setStarImages(1)
        ratings = 1
    }
    
    @IBAction func starTwoBtn(_ sender: UIButton) {
        setStarImages(2)
        ratings = 2
    }
    
    @IBAction func starThreeBtn(_ sender: Any) {
        setStarImages(3)
        ratings = 3
    }

    @IBAction func starFourBtn(_ sender: Any) {
        setStarImages(4)
        ratings = 4
    }
    
    @IBAction func starFiveBtn(_ sender: Any) {
        setStarImages(5)
        ratings = 5
    }
    

    @IBAction func btnSubmit(_ sender: Any) {
//        var feeback = feebackTV.text ?? ""
//        if feebackTV.text == "Share feedback with driver." {
//            feeback = ""
//        }
//
//        if feeback == "" {
//            SKToast.show(withMessage: "Please enter feedback.")
//            return
//        }
        var params : JSONDictionary {
            let att: [String:Any] = [
                "customer_id": objEndTripModal?.customer_id ?? 0,
                "given_rating": ratings,
                "engagement_id": objEndTripModal?.engagement_id ?? 0,
            ] as [String : Any]
            return att
        }
        viewModel.rateCustomer(params) {
            VDRouter.goToSaveUserVC()
        }
    }

    @IBAction func btnSkip(_ sender: Any) {
//        if self.viewcontrollerType == 1 {
//            self.dismiss(animated: true)
//        } else {
            let story = UIStoryboard(name: "Ratings", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "NeedHelpVC") as! NeedHelpVC
            vc.objEndTripModal = objEndTripModal
        self.navigationController?.pushViewController(vc, animated: true)
       // }
    }
    

    func setStarImages(_ count: Int) {

        starOne.image = UIImage(named: "star 1")
        starTwo.image = UIImage(named: "star 1")
        starThree.image = UIImage(named: "star 1")
        starfour.image = UIImage(named: "star 1")
        starFive.image = UIImage(named: "star 1")

//        1 Star- Worst
//        2 Star- Bad
//        3 Star- Good
//        4 Star- Better
//        5 Star- Best

        if count == 1 {
            starTwo.image = UIImage(named: "starDisable 1")
            starThree.image = UIImage(named: "starDisable 1")
            starfour.image = UIImage(named: "starDisable 1")
            starFive.image = UIImage(named: "starDisable 1")
            ratingLbl.text = "Worst"
        } else if count == 2 {
            starThree.image = UIImage(named: "starDisable 1")
            starfour.image = UIImage(named: "starDisable 1")
            starFive.image = UIImage(named: "starDisable 1")
            ratingLbl.text = "Bad"
        } else if count == 3 {
            starfour.image = UIImage(named: "starDisable 1")
            starFive.image = UIImage(named: "starDisable 1")
            ratingLbl.text = "Good"
        } else if count == 4 {
            starFive.image = UIImage(named: "starDisable 1")
            ratingLbl.text = "Better"
        } else if count == 5 {
           // starFive.image = UIImage(named: "starDisable")
            ratingLbl.text = "Best"
        }
    }
}

