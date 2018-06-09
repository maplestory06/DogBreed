//
//  ScreenFactors.swift
//  DogBread
//
//  Created by Yue Shen on 6/8/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit

let screenWidth: CGFloat = UIScreen.main.bounds.width
let screenHeight: CGFloat = UIScreen.main.bounds.height
let screenWidthFactor: CGFloat = {
    if UIScreen.main.bounds.height == 812 {
        return 375 / 414
    } else {
        return UIScreen.main.bounds.width / 414
    }
}()
let screenHeightFactor: CGFloat = {
    if UIScreen.main.bounds.height == 812 {
        return 667 / 736
    } else {
        return UIScreen.main.bounds.height / 736
    }
}()
let device_offset_top: CGFloat = {
    if UIScreen.main.bounds.height == 812 {
        return 24
    } else {
        return 0
    }
}()
let device_offset_bot: CGFloat = {
    if UIScreen.main.bounds.height == 812 {
        return 30
    } else {
        return 0
    }
}()
let device_offset_bot_main: CGFloat = {
    if UIScreen.main.bounds.height == 812 {
        return 22
    } else {
        return 0
    }
}()
