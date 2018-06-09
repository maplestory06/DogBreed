//
//  DogListCell.swift
//  DogBread
//
//  Created by Yue Shen on 6/8/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit
import SwiftyJSON

class DogListCell: UITableViewCell {
    
    private var imgItem: UIImageView!
    private var lblTitle: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadContent()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgItem.image = nil
    }
    
    private func loadContent() {
        
        imgItem = UIImageView()
        imgItem.clipsToBounds = true
        imgItem.layer.cornerRadius = 5
        imgItem.backgroundColor = .lightGray
        addSubview(imgItem)
        
        lblTitle = UILabel()
        lblTitle.numberOfLines = 0
        lblTitle.font = lblTitle.font.withSize(25)
        addSubview(lblTitle)
        addConstraintsWithFormat("H:|-20-[v0(60)]-25-[v1]-15-|", options: [], views: imgItem, lblTitle)
        addConstraintsWithFormat("V:|-20-[v0(60)]", options: [], views: imgItem)
        addConstraintsWithFormat("V:|-10-[v0]-10-|", options: [], views: lblTitle)
    }
    
    public func configureCell(data: DogListViewModel) {
        
        func downloadImage(url: String) {
            ImageDownloader.shared.downloadImage(url: url) { (image) in
                DispatchQueue.main.async { [weak self] in
                    self?.imgItem.image = image
                }
            }
        }
        
        lblTitle.text = data.dogBreed.capitalizingFirstLetter()
        
        if let url = data.imgURL {
            downloadImage(url: url)
        } else {
            Methods.shared.getBreedRandomImageURL(breed: data.dogBreed) { (status, result) in
                guard status / 2 == 100 else { return }
                let json = JSON(result)
                guard json["status"].stringValue == "success" else { return }
                let url = json["message"].stringValue
                data.imgURL = url
                downloadImage(url: url)
            }
        }
    }
}
