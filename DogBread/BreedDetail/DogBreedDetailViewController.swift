//
//  DogBreedDetailViewController.swift
//  DogBread
//
//  Created by Yue Shen on 6/8/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit
import SwiftyJSON

class DogBreedDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var breed: String = ""
    private var clctViewDogDetail: UICollectionView!
    public var dogListViewModel: DogListViewModel? {
        didSet {
            if let dogBreed = dogListViewModel?.dogBreed {
                self.title = dogBreed.capitalizingFirstLetter()
                self.breed = dogBreed
            }
        }
    }
    private var animatedImgView: UIImageView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        getDetail()
    }
    
    // MARK: - UI Setups
    
    private func setupCollection() {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: -0.5, bottom: 1, right: -0.5)
        layout.itemSize = CGSize(width: (screenWidth+1) / 3, height: (screenWidth+1) / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        clctViewDogDetail = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        clctViewDogDetail.delegate = self
        clctViewDogDetail.dataSource = self
        clctViewDogDetail.register(DogDetailCell.self, forCellWithReuseIdentifier: "DogDetailCell")
        clctViewDogDetail.backgroundColor = .white
        
        view.addSubview(clctViewDogDetail)
    }
    
    // MARK: - Get Dog Breed List
    
    @objc private func getDetail() {
        Methods.shared.getDogDetail(breed: self.breed) { (status, result) in
            guard status / 2 == 100 else { return }
            let list = JSON(result)
            guard list["status"].stringValue == "success" else { return }
            let urls = list["message"].arrayValue
            self.dogListViewModel?.imgURLs = urls.map({ $0.stringValue })
            self.clctViewDogDetail.reloadData()
        }
    }
    
    // MARK: - UICollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let viewModel = dogListViewModel {
            return viewModel.imgURLs.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogDetailCell", for: indexPath) as! DogDetailCell
        if let viewModel = dogListViewModel {
            let url = viewModel.imgURLs[indexPath.row]
            cell.configureCell(url: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DogDetailCell {
            let vc = PhotoViewController()
            vc.modalPresentationStyle = .overCurrentContext
            var frame = cell.frame
            frame = collectionView.convert(frame, to: collectionView.superview)
            vc.originFrame = frame
            vc.image = cell.img.image
            present(vc, animated: false, completion: nil)
        }
    }
}
