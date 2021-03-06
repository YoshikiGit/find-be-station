//
//  CommonValue.swift
//  FindBeStation
//
//  Created by 佐藤利紀 on 2019/12/08.
//  Copyright © 2019 Yoshiki Sato. All rights reserved.
//

import Foundation

class CommonValue {
    // アクセスキー
    static let accessKey: String = "LE_P49gfgGtp2fQk"
    
    // 検索画面から駅名補完画面へ渡すモード
    static let findMode: String = "findMode"
    
    // 駅登録画面から駅名補完画面へ渡すモード
    static let regMode: String = "regMode"
    
    // ========== mapのキー =========
    // 補完画面に渡す駅ナンバーのキー
    static let stationNoKey: String  = "stationNo"
    
    // 出発駅を格納するキー
    static let fromListKey: String = "fromList"
    
    // 目的駅を格納するキー
    static let toListKey: String = "toList"
    
    // ========== メッセージ =========
    static let msg_0001: String = "行き先駅が未登録がです。駅登録画面から駅を登録してください。"
    
    static let msg_0002: String = "駅1-4が未入力です。"
}
