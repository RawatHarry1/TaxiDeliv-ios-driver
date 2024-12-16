////
////  LocalizableElementExtension.swift
////  VenusDriver
////
////  Created by Amit on 11/06/23.
////
//
//import Foundation
//
//extension TTAttributedLabel {
//    func setup(){
//        self.numberOfLines = 0;
//
//        let strTC = "terms and conditions"
//        let strPP = "privacy policy"
//
//        let string = "By signing up or logging in, you agree to our \(strTC) and \(strPP)"
//
//        let nsString = string as NSString
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1.2
//
//        let fullAttributedString = NSAttributedString(string:string, attributes: [
//            NSAttributedString.Key.paragraphStyle: paragraphStyle,
//            NSAttributedString.Key.foregroundColor: UIColor.black.cgColor,
//        ])
//        self.textAlignment = .center
//        self.attributedText = fullAttributedString;
//
//        let rangeTC = nsString.range(of: strTC)
//        let rangePP = nsString.range(of: strPP)
//
//        let ppLinkAttributes: [String: Any] = [
//            NSAttributedString.Key.foregroundColor.rawValue: UIColor.blue.cgColor,
//            NSAttributedString.Key.underlineStyle.rawValue: false,
//        ]
//        let ppActiveLinkAttributes: [String: Any] = [
//            NSAttributedString.Key.foregroundColor.rawValue: UIColor.blue.cgColor,
//            NSAttributedString.Key.underlineStyle.rawValue: false,
//        ]
//
//        self.activeLinkAttributes = ppActiveLinkAttributes
//        self.linkAttributes = ppLinkAttributes
//
//        let urlTC = URL(string: "action://TC")!
//        let urlPP = URL(string: "action://PP")!
//        self.addLink(to: urlTC, with: rangeTC)
//        self.addLink(to: urlPP, with: rangePP)
//
//        self.textColor = UIColor.black;
//        self.delegate = self;
//    }
//
//    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
//        if url.absoluteString == "action://TC" {
////            print("TC click")
//        }
//        else if url.absoluteString == "action://PP" {
////            print("PP click")
//        }
//    }
//
//
//}
//
//
