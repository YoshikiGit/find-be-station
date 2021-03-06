//
//  CommonPart.swift
//  FindBeStation
//
//  Created by 佐藤利紀 on 2019/11/30.
//  Copyright © 2019 Yoshiki Sato. All rights reserved.
//

import Foundation

class CommonPart {


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "、" || string == "。" {
            return false
        }
        return true
    }

}
