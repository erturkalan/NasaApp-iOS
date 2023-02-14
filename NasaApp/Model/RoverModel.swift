//
//  RoverModel.swift
//  NasaApp
//
//  Created by Ertürk Alan on 7.02.2023.
//

import Foundation

struct RoverModel: Decodable {
    let id: Int
    let name: String
    let landing_date: String
    let launch_date: String
    let status: String
}
