//
//  PackageListTblCell.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 13/11/24.
//

import UIKit
protocol CollectionViewCellDelegate: AnyObject {
    func didSelectItem(url: String)
}
class PackageListTblCell: UITableViewCell {
    @IBOutlet weak var lblTopDelivery: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var imagesStackView: UIStackView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var deliveryStackView: UIStackView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var collectionVwDropOffImgs: UICollectionView!
    @IBOutlet weak var btnreject: UIButton!
    var didPressAccept: (()->Void)?
    var didPressReject: (()->Void)?
    var deliveryPackages : DeliveryPackages?
    weak var delegate: CollectionViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.addShadowView()
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
        
        collectionVwDropOffImgs.delegate = self
        collectionVwDropOffImgs.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnAcceptAction(_ sender: Any) {
      //  self.didPressAccept!()
    }
    
    @IBAction func btnRejectAction(_ sender: Any) {
        self.didPressReject!()
    }
}

extension PackageListTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewImages{
//            if imagesArr?.count ?? 0 > 0{
//                return imagesArr?.count ?? 0
//            }else{
                return deliveryPackages?.package_image_while_pickup?.count ?? 0
          //  }
        }else{
            return deliveryPackages?.package_image_while_drop_off?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewImages{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionCell", for: indexPath) as! ImagesCollectionCell
            
//            if imagesArr?.count ?? 0 > 0{
//                cell.imgViewImages.setImage(imagesArr?[indexPath.row] ?? "", placeHolder: nil)
//            
//                
//            }else{
                if deliveryPackages?.package_image_while_pickup?.count ?? 0 > 0
                {
                    cell.imgViewImages.setImage(deliveryPackages?.package_image_while_pickup?[indexPath.row] ?? "", placeHolder: nil)

                }
           // }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionCell", for: indexPath) as! ImagesCollectionCell
            if deliveryPackages?.package_image_while_drop_off?.count ?? 0 > 0
            {
                cell.imgViewImages.setImage(deliveryPackages?.package_image_while_drop_off?[indexPath.row] ?? "", placeHolder: nil)

            }
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //  guard let tableViewIndexPath = tableViewIndexPath else { return }
        
        if collectionView == collectionViewImages{
            if deliveryPackages?.package_image_while_pickup?.count ?? 0 > 0{
                let urlStr = deliveryPackages?.package_image_while_pickup?[indexPath.row] ?? ""
                
                delegate?.didSelectItem(url:urlStr)

                
            }
        }else{
            if deliveryPackages?.package_image_while_drop_off?.count ?? 0 > 0{
                let urlStr = deliveryPackages?.package_image_while_drop_off?[indexPath.row] ?? ""
                
                delegate?.didSelectItem(url:urlStr)

                
            }
//            let urlStr = deliveryImagesArr?[indexPath.row] ?? ""
//            delegate?.didSelectItem(url:urlStr)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if imagesArr?.count ?? 0 > 0{
//            return CGSizeMake(58, 58)
//        }else{
            return CGSizeMake(58, 58)
//        }
       
    }
    
    
    
}
