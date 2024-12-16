//
//  SIIntroScreensVC.swift
//  VenusDriver
//
//  Created by Amit on 22/07/23.
//

import UIKit

class SIIntroScreensVC: VDBaseVC {

    @IBOutlet weak var introCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnNext: VDButton!

    var currentIndex = 0

    //  To create ViewModel
    static func create() -> SIIntroScreensVC {
        let obj = SIIntroScreensVC.instantiate(fromAppStoryboard: .saloneMain)
        return obj
    }

    override func initialSetup() {
        VDUserDefaults.save(value: true, forKey: .showIntroScreens)
        pageControl.numberOfPages = 3
        self.introCollectionView.register(UINib(nibName: "SIIntroCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SIIntroCollectionCell")
        introCollectionView.delegate = self
        introCollectionView.dataSource = self
    }
}

extension SIIntroScreensVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SIIntroCollectionCell", for: indexPath) as? SIIntroCollectionCell
        cell?.updateUIWithData(index: indexPath.item)
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentIndex == 2 {
            btnNext.setTitle("Get started", for: .normal)
        } else {
            btnNext.setTitle("Next", for: .normal)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.navigationController?.pushViewController(VDWelcomeVC.create(), animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var currentIndex:CGFloat = introCollectionView.contentOffset.x / introCollectionView.frame.size.width
        //self.pageControl.currentPage = indexPath.section
        pageControl.currentPage = Int(currentIndex)
        self.currentIndex = Int(currentIndex)
        if currentIndex == 2 {
            btnNext.setTitle("Get started", for: .normal)
        } else {
            btnNext.setTitle("Next", for: .normal)
        }
    }
    

}

extension SIIntroScreensVC {
    private func configureCellSize(index : Int) -> CGSize {
        guard let cell = Bundle.main.loadNibNamed("SIIntroCollectionCell", owner: self, options:nil)?.first as? SIIntroCollectionCell else { return CGSize(width: 0, height: 0) }
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

extension SIIntroScreensVC {
    @IBAction func skipBtn(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDWelcomeVC.create(), animated: true)
    }

    @IBAction func nextBtn(_ sender: UIButton) {
        if currentIndex == 2 {
            self.navigationController?.pushViewController(VDWelcomeVC.create(), animated: true)
        }else{
           currentIndex += 1
            pageControl.currentPage = currentIndex
            if #available(iOS 13.0, *) {
                let window = sharedAppDelegate.window
                let topPadding = 45
                let bottomPadding = window?.safeAreaInsets.bottom
                self.introCollectionView.setContentOffset(CGPoint(x: Int((UIScreen.main.bounds.width)) * currentIndex, y: -Int((topPadding))), animated: true)
            }else{
                let window = sharedAppDelegate.window
                let topPadding = 45
                let bottomPadding = window?.safeAreaInsets.bottom
                self.introCollectionView.setContentOffset(CGPoint(x: Int((UIScreen.main.bounds.width)) * currentIndex, y: -Int((topPadding))), animated: true)
            }
        }
    }
}
