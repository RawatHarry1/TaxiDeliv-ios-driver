//
//  PackageThreeCell.swift
//  VenusDriver
//
//  Created by Paramveer Singh on 12/01/25.
//

import UIKit

class PackageThreeCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblPickedUpSeperator: UILabel!
    
    @IBOutlet weak var heightCell: NSLayoutConstraint!
    @IBOutlet weak var lblDeliveredIImages: UILabel!
    @IBOutlet weak var deliveredImageView: UIView!
    @IBOutlet weak var pickUpImagesStack: UIStackView!
    @IBOutlet weak var lblDeliveredSeparator: UILabel!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    
    @IBOutlet var collectionViewDropOff: UICollectionView!
    @IBOutlet var collectionViewPickup: UICollectionView!
    var didPressAccept: (()->Void)?
    var didPressReject: (()->Void)?
    var objDelivery_packages: DeliveryPackageHistoryData?
    weak var delegate: CollectionViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.addShadowView()
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
        collectionViewPickup.delegate = self
        collectionViewPickup.dataSource = self
        collectionViewDropOff.delegate = self
        collectionViewDropOff.dataSource = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
extension PackageThreeCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewImages
        {
            return objDelivery_packages?.package_images_by_customer?.count ?? 0

        }
        else if collectionView == collectionViewPickup
        {
            return objDelivery_packages?.package_image_while_pickup?.count ?? 0

        }
        return objDelivery_packages?.package_image_while_drop_off?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: "ImageCollCellMain", bundle: nil), forCellWithReuseIdentifier: "ImageCollCellMain")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollCellMain", for: indexPath) as! ImageCollCellMain

        if collectionView == collectionViewImages
        {

            cell.imgMain.setImage(objDelivery_packages?.package_images_by_customer?[indexPath.row] ?? "", placeHolder: nil)
       
        }
        else if collectionView == collectionViewPickup
        {

            cell.imgMain.setImage(objDelivery_packages?.package_image_while_pickup?[indexPath.row] ?? "", placeHolder: nil)
    
        }
        else
        {

            cell.imgMain.setImage(objDelivery_packages?.package_image_while_drop_off?[indexPath.row] ?? "", placeHolder: nil)
         
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var urlStr = ""
        if collectionView == collectionViewImages
        {

            urlStr = objDelivery_packages?.package_image_while_pickup?[indexPath.row] ?? ""
       
        }
        else if collectionView == collectionViewPickup
        {

            urlStr =  objDelivery_packages?.package_image_while_pickup?[indexPath.row] ?? ""
    
        }
        else
        {

            urlStr = objDelivery_packages?.package_image_while_drop_off?[indexPath.row] ?? ""
         
        }
        delegate?.didSelectItem(url:urlStr)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(58, 58)
    }
    
    
    
}
class ImagesCollectionCell3: UICollectionViewCell {
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgViewImages: UIImageView!
    
    var didPressDelete : (()-> Void)?
    
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        self.didPressDelete!()
    }
    
}

class ImagesCollectionCell4: UICollectionViewCell {
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgViewImages: UIImageView!
    
    var didPressDelete : (()-> Void)?
    
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        self.didPressDelete!()
    }
    
}


class ImagesCollectionCell5: UICollectionViewCell {
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgViewImages: UIImageView!
    
    var didPressDelete : (()-> Void)?
    
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        self.didPressDelete!()
    }
    
}
