//
//  WallpaperCell.swift
//  NFT Wallpaper
//
//  Created by Mac on 13/02/2022.
//

import UIKit
import AVFoundation

class WallpaperCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var anime: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.borderColor = UIColor(named: "blue")?.cgColor
        backView.layer.borderWidth = 2
        backView.layer.cornerRadius = 20
        
       
        // Initialization code
    }
    
 

}
