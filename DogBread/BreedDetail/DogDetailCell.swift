//
//  DogDetailCell.swift
//  DogBread
//
//  Created by Yue Shen on 6/8/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit

class DogDetailCell: UICollectionViewCell {
    
    var img: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadCellItems()
        backgroundColor = .lightGray
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = nil
    }
    
    private func loadCellItems() {
        img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        addSubview(img)
        addConstraintsWithFormat("H:|-0-[v0]-0-|", options: [], views: img)
        addConstraintsWithFormat("V:|-0-[v0]-0-|", options: [], views: img)
    }
    
    public func configureCell(url: String) {
        ImageDownloader.shared.downloadImage(url: url) { (image) in
            DispatchQueue.main.async { [weak self] in
                self?.img.image = image
            }
        }
    }
}

class ImageDownloadOperation: Operation {

    var url: String
    
    init(url: String) {
        self.url = url
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
    }
}
