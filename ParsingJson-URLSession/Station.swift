//
//  Station.swift
//  ParsingJson-URLSession
//
//  Created by Brendon Cecilio on 8/4/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import Foundation

struct ResultWrapper: Decodable {
    let data: StationsWrapper
}

struct StationsWrapper: Decodable {
    let stations: [Station]
}

struct Station: Decodable, Hashable {
    let stationType: String
    let latitude: Double
    let longitude: Double
    let capacity: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case stationType = "station_type"
        case name
        case latitude = "lat"
        case longitude = "lon"
        case capacity
    }
}
