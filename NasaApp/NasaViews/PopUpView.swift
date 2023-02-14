//
//  PopUpView.swift
//  NasaApp
//
//  Created by Ertürk Alan on 11.02.2023.
//

import Foundation
import UIKit
import Kingfisher

class PopUpView: UIView {
    let imageView = UIImageView()
    let containerView = UIView()
    let stackView = UIStackView()
    let roverNameLabel = UILabel()
    let photoDateLabel = UILabel()
    let cameraNameLabel = UILabel()
    let statusLabel = UILabel()
    let launchDateLabel = UILabel()
    let landingDateLabel = UILabel()
    let closeButton = UIButton()
    
    private var image: String
    private var roverName: String
    private var photoDate: String
    private var cameraName: String
    private var status: String
    private var launchDate: String
    private var landingDate: String
    
    init(frame: CGRect, image: String, roverName: String, photoDate: String, cameraName: String, status: String, launchDate: String, landingDate: String) {
        self.image = image
        self.roverName = roverName
        self.photoDate = photoDate
        self.cameraName = cameraName
        self.status = status
        self.launchDate = launchDate
        self.landingDate = landingDate
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubview(containerView)
        containerView.anchorWithCenter(centerX: self.centerXAnchor, centerY: self.centerYAnchor, size: CGSize(width: 360, height: 440))
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, padding: UIEdgeInsets(top: 6, left: 6, bottom: -6, right: -6))
       
        
  
        
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
//        closeButton.setTitle("close", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.anchor(top: nil, left: nil, bottom: nil, right: nil, size: CGSize(width: 32, height: 32))
        let closeStack = UIStackView()
        closeStack.axis = .vertical
        closeStack.alignment = .trailing
        closeStack.addArrangedSubview(closeButton)
        stackView.addArrangedSubview(closeStack)
        
        if var url = URLComponents(string: image){
            url.scheme = "https"
            if let https = url.string{
                imageView.fetchImage(from: https)
            }
        }
        stackView.addArrangedSubview(imageView)
        
        roverNameLabel.text = "Rover Name: " + roverName
        roverNameLabel.textAlignment = .center
        stackView.addArrangedSubview(roverNameLabel)
        
        photoDateLabel.text = "Photo Date: " + photoDate
        photoDateLabel.textAlignment = .center
        stackView.addArrangedSubview(photoDateLabel)
        
        cameraNameLabel.text = "Camera Name: " + cameraName
        cameraNameLabel.textAlignment = .center
        stackView.addArrangedSubview(cameraNameLabel)
        
        statusLabel.text = "Status: " + status
        statusLabel.textAlignment = .center
        stackView.addArrangedSubview(statusLabel)
        
        launchDateLabel.text = "Launch Date: " + launchDate
        launchDateLabel.textAlignment = .center
        stackView.addArrangedSubview(launchDateLabel)
        
        landingDateLabel.text = "Landing Date: " + launchDate
        landingDateLabel.textAlignment = .center
        stackView.addArrangedSubview(landingDateLabel)
        
    }
    
    @objc func didTapCloseButton() {
        self.removeFromSuperview()
    }
}
