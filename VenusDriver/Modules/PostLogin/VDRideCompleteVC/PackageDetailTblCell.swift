//
//  PackageDetailTblCell.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 05/11/24.
//

import UIKit
import SDWebImage
class PackageDetailTblCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    
    @IBOutlet weak var collectionViewImages: UICollectionView!
    
    var didPressAccept: (()->Void)?
    var didPressReject: (()->Void)?
    var objDelivery_packages: DeliveryPackageData?
    var deliveryPackages : [DeliveryPackages]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.addShadowView()
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnAcceptAction(_ sender: Any) {
        self.didPressAccept!()
    }
    
    @IBAction func btnRejectAction(_ sender: Any) {
        self.didPressReject!()
    }
    
}
extension PackageDetailTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return objDelivery_packages?.image?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionCell", for: indexPath) as! ImagesCollectionCell
        var url = URL(string:  objDelivery_packages?.image?[indexPath.row] ?? "")
//        var url1 = URL(string:   "https://picsum.photos/id/237/200/300")
        cell.imgViewImages.sd_setImage(with: url, placeholderImage: nil, options: [.refreshCached, .highPriority], completed: nil)

//        cell.imgViewImages.sd_setImage(with: url1 , placeholderImage: nil)
//        cell.imgViewImages.sd_setImage(with: url , placeholderImage: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(58, 58)
    }
    
    
    
}
