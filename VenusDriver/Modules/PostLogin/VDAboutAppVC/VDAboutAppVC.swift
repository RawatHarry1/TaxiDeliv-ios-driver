//
//  VCAboutAppVC.swift
//  VenusCustomer
//
//  Created by Amit on 09/07/23.
//

import UIKit
import MessageUI
import SafariServices

class VDAboutAppVC: VDBaseVC, SFSafariViewControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var aboutTableView: UITableView!
    @IBOutlet weak var sideMenuBtn: UIButton!

    private var informationUrls: InformationURLModel!

    //  To create ViewModel
    static func create(_ urls : InformationURLModel) -> VDAboutAppVC {
        let obj = VDAboutAppVC.instantiate(fromAppStoryboard: .postLogin)
        obj.informationUrls = urls
        return obj
    }

    override func initialSetup() {
        aboutTableView.delegate = self
        aboutTableView.dataSource = self
        aboutTableView.register(UINib(nibName: "VDAboutAppCell", bundle: nil), forCellReuseIdentifier: "VDAboutAppCell")
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            if let email = self.informationUrls.support_email {
                mail.setToRecipients([email])
            }
            self.present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            print("email is not supported")
        }
    }

    func openSafariWithURL(_ url: String){
        guard let url = URL(string: url) else { return }

        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
            // Can open with SFSafariViewController
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        } else {
            // Scheme is not supported or no scheme is given, use openURL
            SKToast.show(withMessage: "Invalid URL")
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }

    @IBAction func btnBack(_ sender: UIButton) {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.showLeftView()
    }
}

extension VDAboutAppVC : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VDAboutAppCell", for: indexPath) as! VDAboutAppCell
        cell.setupUI(indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            let url = URL(string: "https://itunes.apple.com/in/app/")
            UIApplication.shared.open(url!)
        case 1 :
            openSafariWithURL(self.informationUrls.facebook_url ?? "")
        case 2 :
            openSafariWithURL(self.informationUrls.legal_url ?? "")
        case 3 :
            openSafariWithURL(self.informationUrls.who_we_are ?? "")
        case 4 :
            openSafariWithURL(self.informationUrls.privacy_policy ?? "")
        case 5 :
            sendEmail()
        default :
            break
        }
    }
}

extension VDAboutAppVC : MFMailComposeViewControllerDelegate {

//    //MARK: MFMail Compose ViewController Delegate method
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true)
//
//    }
     func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
          //  print("Emailing attempt, error="+(error?.localizedDescription)!)
            switch (result){
            case MFMailComposeResult.cancelled:
                print("Mail cancelled");
                break;
            case MFMailComposeResult.saved:
                print("Mail saved");
                break;
            case MFMailComposeResult.sent:
                print("Mail sent");
                SKToast.show(withMessage: "Mail sent successfully")
                break;
            case MFMailComposeResult.failed:
                SKToast.show(withMessage: "Failed to sent mail")
                print("Mail sent failure: %@", error?.localizedDescription);
                break;
            default:
                break;
            }
            // Close the Mail Interface
            controller.dismiss(animated: true)
        }
}
