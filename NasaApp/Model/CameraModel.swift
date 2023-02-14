//
//  CameraModel.swift
//  NasaApp
//
//  Created by Ertürk Alan on 7.02.2023.
//

import Foundation


struct CameraModel: Decodable {
    let id: Int
    let name: String
    let rover_id: Int
    let full_name: String
}
