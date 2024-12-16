//
//  VDDocumentsVC.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import UIKit

class VDDocumentsVC: VDBaseVC {
    // MARK: - Outlets
    @IBOutlet weak var documentCollection: UICollectionView!

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDDocumentsVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        self.documentCollection.register(UINib(nibName: "VDDocumentCell", bundle: nil), forCellWithReuseIdentifier: "VDDocumentCell")
        documentCollection.delegate = self
        documentCollection.dataSource = self
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSubmit(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.pushViewController(VDPayoutInfoVC.create(), animated: true)
    }
}

extension VDDocumentsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VDDocumentCell", for: indexPath) as? VDDocumentCell
        cell?.updateUI(indexPath.item)
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 220)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
