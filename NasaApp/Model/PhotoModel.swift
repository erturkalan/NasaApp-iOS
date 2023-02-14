//
//  PhotoModel.swift
//  NasaApp
//
//  Created by Ertürk Alan on 7.02.2023.
//

import Foundation

struct PhotoModel: Decodable {
    let id: Int
    let camera: CameraModel
    let img_src: String
    let earth_date: String
    let rover: RoverModel
}

struct Photos: Decodable {
    let photos: [PhotoModel]
}
