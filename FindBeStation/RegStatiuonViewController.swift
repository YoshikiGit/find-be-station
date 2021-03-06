//
//  RegStatiuonViewController.swift
//  FindBeStation
//
//  Created by 佐藤利紀 on 2019/11/17.
//  Copyright © 2019 Yoshiki Sato. All rights reserved.
//

import UIKit

class RegStatiuonViewController: UIViewController, UITextFieldDelegate ,UINavigationControllerDelegate,UISearchBarDelegate {
    // スクロールビュー
    @IBOutlet weak var myScrollView: UIScrollView!

    // スクロールビューのサブビュー
    @IBOutlet weak var contentView: UIView!
    // 駅1
    @IBOutlet weak var station1: UITextField!
    // 駅2
    @IBOutlet weak var station2: UITextField!
    // 駅3
    @IBOutlet weak var station3: UITextField!
    // 駅4
    @IBOutlet weak var station4: UITextField!
    // 駅5
    @IBOutlet weak var station5: UITextField!
    
    // ロード済フラグ
    var flgViewDidLoad:Int = 0
    
    @IBOutlet weak var clear1: UIButton!
    
    @IBOutlet weak var clear2: UIButton!
    
    @IBOutlet weak var clear3: UIButton!
    
    @IBOutlet weak var clear4: UIButton!
    
    @IBOutlet weak var clear5: UIButton!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        station1.delegate = self
        station2.delegate = self
        station3.delegate = self
        station4.delegate = self
        station5.delegate = self
        
        flgViewDidLoad += 1
        // スクロールビュー領域をß指定する
        let scrollFrame = CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height-20)
        myScrollView.frame = scrollFrame

        // コンテンツのサイズを指定する
        let contentRect = contentView.bounds
        myScrollView.contentSize = CGSize(width:contentRect.width, height: contentRect.height)
        
        // 前回値の復元
        var toList:[String]? = defaults.object(forKey: CommonValue.toListKey) as! [String]?
        if (toList != nil) {
            station1.text = toList?[0]
            station2.text = toList?[1]
            station3.text = toList?[2]
            station4.text = toList?[3]
            station5.text = toList?[4]
        }
        

        //defaults.object(forKey: "station1")
        // Do any additional setup after loading the view.
    }
    
    // Menuに戻った時の処理
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        
        if viewController is ViewController {
            addStation()
        }
    }

    // 登録駅のリストを作成
    func addStation() {
        var toList:[String] = []
        toList.append(station1.text as! String)
        toList.append(station2.text as! String)
        toList.append(station3.text as! String)
        toList.append(station4.text as! String)
        toList.append(station5.text as! String)
        
        defaults.set(toList, forKey: CommonValue.toListKey)
    }
    
    // フォーカスがあたった際に呼び出されるメソッド.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        defaults.set(String(textField.tag), forKey: "stationNo")
        
        let mode: String = CommonValue.regMode
        // 画面遷移
        self.performSegue(withIdentifier: "toAutoComplete", sender: mode)
    }

    //画面遷移から戻ってきたときに実行する関数
    override func viewWillAppear(_ animated: Bool) {
        
        if (flgViewDidLoad != 0) {
            // 前回値の復元
            var toList:[String]? = defaults.object(forKey: CommonValue.toListKey) as! [String]?
            if (toList != nil) {
                station1.text = toList?[0]
                station2.text = toList?[1]
                station3.text = toList?[2]
                station4.text = toList?[3]
                station5.text = toList?[4]
            }
        }
        
    }
  //Segueの初期化を通知するメソッドをオーバーライドする。senderにはperformSegue()で渡した値が入る。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAutoComplete" {
            let autoCompleteViewController = segue.destination as! AutoCompleteViewController
            autoCompleteViewController.mode = sender as! String
        }
    }
    
    @IBAction func clearStation1(_ sender: Any) {
        station1.text = ""
         var toList:[String]? = defaults.object(forKey: CommonValue.toListKey) as! [String]?
        
        if (toList != nil) {
            toList?[0] = ""
            defaults.set(toList, forKey: CommonValue.toListKey)
        }
        
    }
    
    @IBAction func clearStation2(_ sender: Any) {
        station2.text = ""
        var toList:[String]? = defaults.object(forKey: CommonValue.toListKey) as! [String]?
        if (toList != nil) {
            toList?[0] = ""
            defaults.set(toList, forKey: CommonValue.toListKey)
        }
        
    }
    
    @IBAction func clearStation3(_ sender: Any) {
        station3.text = ""
        var toList:[String]? = defaults.object(forKey: CommonValue.toListKey) as! [String]?
        if (toList != nil) {
            toList?[0] = ""
            defaults.set(toList, forKey: CommonValue.toListKey)
        }
        
    }
    
    @IBAction func clearStation4(_ sender: Any) {
        station4.text = ""
        var toList:[String]? = defaults.object(forKey: CommonValue.toListKey) as! [String]?
        if (toList != nil) {
            toList?[0] = ""
            defaults.set(toList, forKey: CommonValue.toListKey)
        }
        
    }
    
    @IBAction func clearStation5(_ sender: Any) {
        station5.text = ""
        var toList:[String]? = defaults.object(forKey: CommonValue.toListKey) as! [String]?
        if (toList != nil) {
            toList?[0] = ""
            defaults.set(toList, forKey: CommonValue.toListKey)
        }
        
    }
    
    @IBAction func allClear(_ sender: Any) {
        station1.text = ""
        station2.text = ""
        station3.text = ""
        station4.text = ""
        station5.text = ""
        
        var toList:[String]? = defaults.object(forKey: CommonValue.toListKey) as! [String]?
                
        if (toList != nil) {
            for tmp in 0...4 {
                toList?[tmp] = ""
            }
            defaults.set(toList, forKey: CommonValue.toListKey)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}


