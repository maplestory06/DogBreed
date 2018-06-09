//
//  PhotoViewController.swift
//  DogBread
//
//  Created by Yue Shen on 6/8/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var animatedImgView: UIImageView!
    var originFrame = CGRect.zero
    var image: UIImage?
    var dimBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupDimBackground()
        setupImageView()
        setupTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    private func setupImageView() {
        animatedImgView = UIImageView(frame: originFrame)
        animatedImgView.clipsToBounds = true
        animatedImgView.contentMode = .scaleAspectFill
        animatedImgView.image = image
        animatedImgView.isUserInteractionEnabled = true
        view.addSubview(animatedImgView)
    }
    
    private func setupDimBackground() {
        dimBack = UIView(frame: view.frame)
        dimBack.backgroundColor = .black
        dimBack.alpha = 0
        view.addSubview(dimBack)
    }
    
    private func setupTap() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGes)
        
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        animatedImgView.addGestureRecognizer(panGes)
//        panGes.require(toFail: tapGes)
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.animatedImgView.frame.size = CGSize(width: screenWidth, height: screenWidth)
            self.animatedImgView.center = self.view.center
            self.dimBack.alpha = 0.75
        }, completion: nil)
    }
    
    private func endAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.animatedImgView.frame = self.originFrame
            self.dimBack.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    // MARK: - Actions
    @objc private func handleTap() {
        endAnimation()
    }
    
    var start: CGFloat = 0
    
    @objc private func handlePan(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            let location = pan.location(in: view)
            start = location.y
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            let y_after = animatedImgView.center.y
            if fabsf(Float(y_after - screenHeight/2)) > Float(screenHeight/6) {
                endAnimation()
            } else {
                startAnimation()
            }
        } else {
            let location = pan.location(in: view)
            let end = location.y
            print(end - start)
            var value = fabs(fabs(Double(end - start)) / 300 - 1)
            if value > 0.75 { value = 0.75 }
            dimBack.alpha = CGFloat(value)
            
            let translation = pan.translation(in: view)
            animatedImgView.frame.origin.y += translation.y
            pan.setTranslation(CGPoint.zero, in: view)
        }
    }
}
