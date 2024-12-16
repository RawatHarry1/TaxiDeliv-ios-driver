//
//  VDIntroVC.swift
//  VenusDriver
//
//  Created by Amit on 10/06/23.
//

import UIKit

class VDIntroVC: VDBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var introCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDIntroVC.instantiate(fromAppStoryboard: .main)
        return obj
    }

    // MARK: - Variables
    private var currentIndex = 0

    override func initialSetup() {
        self.introCollectionView.register(UINib(nibName: "VDIntroCollectionCell", bundle: nil), forCellWithReuseIdentifier: "VDIntroCollectionCell")
        introCollectionView.delegate = self
        introCollectionView.dataSource = self
    }
}

// MARK: - Collection view delegates & data sources
extension VDIntroVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VDIntroCollectionCell", for: indexPath) as? VDIntroCollectionCell
        cell?.updateUIWithData(index: indexPath.item)
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 400)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in introCollectionView.visibleCells {
            let indexPath = introCollectionView.indexPath(for: cell)
            currentIndex = indexPath?.item ?? 0
            pageControl.currentPage = currentIndex
        }
    }
}

extension VDIntroVC {
    private func configureCellSize(index : Int) -> CGSize {
        guard let cell = Bundle.main.loadNibNamed("VDIntroCollectionCell", owner: self, options:nil)?.first as? VDIntroCollectionCell else { return CGSize(width: 0, height: 0) }
        cell.updateUIWithData(index: index)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let width = introCollectionView.width
        let height: CGFloat = 0
        let targetSize = CGSize(width: width, height: height)
        let size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
        return size
    }
}

// MARK: - IBActions
extension VDIntroVC {
    @IBAction func skipBtn(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDWelcomeVC.create(), animated: true)
    }

    @IBAction func nextBtn(_ sender: UIButton) {
        if currentIndex == 2 {
            self.navigationController?.pushViewController(VDWelcomeVC.create(), animated: true)
        } else {
            currentIndex += 1
            pageControl.currentPage = currentIndex
            self.introCollectionView.setContentOffset(CGPoint(x: Int((UIScreen.main.bounds.width)) * currentIndex, y: 0), animated: true)
        }
    }
}
