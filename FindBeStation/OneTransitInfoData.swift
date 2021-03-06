//
//  OneTransitInfoData.swift
//  FindBeStation
//
//  Created by 佐藤利紀 on 2020/01/02.
//  Copyright © 2020 Yoshiki Sato. All rights reserved.
//

import Foundation

public struct OneTransitInfoData {
    public var ResultSet: OneResultSet
}

public struct OneResultSet: Codable {
    public var apiVersion: String?
    public var max: String?
    public var engineVersion: String?
    public var resourceURI: String?
    public var error: String?
    public var offset: String?
    public var Point: OnePoint
}

public struct OnePoint: Codable {
    public var Station: OneStation
    public var Prefecture: OnePrefacture
    public var GeoPoint: OneGeoPoint
}

public struct OneStation: Codable {
    public var code: String
    public var Name: String
    public var `Type`: String
    public var Yomi: String
}

public struct OnePrefacture: Codable {
    public var code: String
    public var Name: String
}

public struct OneGeoPoint: Codable {
    public var longi: String
    public var lati: String
    public var longi_d: String
    public var lati_d: String
    public var gcs: String
}
