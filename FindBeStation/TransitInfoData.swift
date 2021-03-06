//
//  TransitInfoData.swift
//  FindBeStation
//
//  Created by 佐藤利紀 on 2019/12/01.
//  Copyright © 2019 Yoshiki Sato. All rights reserved.
//

import Foundation

public struct TransitInfoData: Codable {
    
    public var ResultSet: ResultSet
}

public struct ResultSet: Codable {
    public var apiVersion: String?
    public var max: String?
    public var engineVersion: String?
    public var resourceURI: String?
    public var error: String?
    public var offset: String?
    public var Point: Array<Point>
}

public struct Point: Codable {
    public var Station: Station
    public var Prefecture: Prefacture
    public var GeoPoint: GeoPoint
}

public struct Station: Codable {
    public var code: String
    public var Name: String
    public var `Type`: String
    public var Yomi: String
}

public struct Prefacture: Codable {
    public var code: String
    public var Name: String
}

public struct GeoPoint: Codable {
    public var longi: String
    public var lati: String
    public var longi_d: String
    public var lati_d: String
    public var gcs: String
}
