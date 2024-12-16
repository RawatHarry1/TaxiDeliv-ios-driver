//
//  VDWelcomeVC.swift
//  VenusDriver
//
//  Created by Amit on 07/06/23.
//

import UIKit

class VDWelcomeVC: VDBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var btnSignIn: VDButton!
    @IBOutlet weak var signUpLabel: TTAttributedLabel!
    @IBOutlet weak var titleLbl: UILabel!

    // MARK: - Variables
    private var attributedString = NSMutableAttributedString()
    private let fullText = "Don’t have an account? Sign Up"

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDWelcomeVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {
        if whiteLabelProperties.packageName == bundleIdentifiers.salone.rawValue {
            titleLbl.text = "Venus"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        sharedAppDelegate.notficationDetails = nil
        RideStatus = .none
        setUpSignUpLabel()
    }

    override func viewDidLayoutSubviews() {
        btnSignIn.updateGradient()
    }
}

// MARK: - IBActions
extension VDWelcomeVC {
    @IBAction func btnSignIn(_ sender: UIButton) {
        let vc = VDLoginVC.create()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnSignUp(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDSignUpVC.create(), animated: true)
    }
}

// MARK: - Set sign up label
extension VDWelcomeVC: TTTAttributedLabelDelegate {
    func setUpSignUpLabel() {
        let clickAble = "Sign Up"
        let nsString = fullText as NSString
        let rangeClickableText = nsString.range(of: clickAble)
        attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : VDColors.textColor.color], range: NSRange(location: 0, length: fullText.count))

        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: VDColors.buttonSelectedOrange.color.cgColor, range: rangeClickableText)
        signUpLabel.attributedText = attributedString
    }

    func pushToView() {
//        self.navigationController?.pushViewController(VDSignUpVC.create(), animated: true)
    }

    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithAddress addressComponents: [AnyHashable : Any]!) {
        pushToView()
    }
}
