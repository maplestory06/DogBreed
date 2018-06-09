//
//  DogListViewModel.swift
//  DogBread
//
//  Created by Yue Shen on 6/8/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import Foundation

class DogListViewModel {
    
    var dogBreed: String
    var imgURL: String?
    var imgURLs = [String]()
    
    init(breed: String) {
        dogBreed = breed
    }
}
