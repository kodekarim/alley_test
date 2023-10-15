//
//  PhotoCollectionViewCell.swift
//  alley-test
//
//  Created by abdul karim on 04/10/23.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivPhoto: UIImageView!
    
    var photo:UIImage? {
        didSet {
            configurePhotoView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurePhotoView() {
        ivPhoto.image = photo
    }

}

extension PhotoCollectionViewCell : ViewFromNib {}
