//
//  PhotoCollectionViewCell.swift
//  NasaApp
//
//  Created by Ertürk Alan on 7.02.2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    
    func setup (with photo: PhotoModel) {
        if var url = URLComponents(string: photo.img_src){
            url.scheme = "https"
            if let https = url.string{
                imageView.fetchImage(from: https)
            }
        }
        idLabel.text = String(photo.id)
    }
}
