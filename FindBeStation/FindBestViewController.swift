//
//  FindBestViewController.swift
//  FindBeStation
//
//  Created by 佐藤利紀 on 2019/11/19.
//  Copyright © 2019 Yoshiki Sato. All rights reserved.
//

import UIKit

class FindBestViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    // 検索ボタン
    @IBOutlet weak var researchBtn: UIButton!
    
    // from駅1
    @IBOutlet weak var station1: UITextField!
    
    // from駅2
    @IBOutlet weak var station2: UITextField!
    
    // from駅3
    @IBOutlet weak var station3: UITextField!
    
    // from駅4
    @IBOutlet weak var station4: UITextField!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    // map
    let defaults = UserDefaults.standard
    
    let subFontSize = 16;

    var flgViewDidLoad:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        station1.delegate = self
        station2.delegate = self
        station3.delegate = self
        station4.delegate = self

        flgViewDidLoad += 1
        
        // スクロールビュー領域をß指定する
        let scrollFrame = CGRect(x: 0, y: 300, width: view.frame.width, height: view.frame.height - 150)
        myScrollView.frame = scrollFrame

        // コンテンツのサイズを指定する
        let contentRect = contentView.bounds
        myScrollView.contentSize = CGSize(width:contentRect.width, height: contentRect.height + 20)
    
        let fromList:[String]? = defaults.object(forKey: "fromList") as! [String]?
        if (fromList != nil) {
            station1.text = fromList?[0]
            station2.text = fromList?[1]
            station3.text = fromList?[2]
            station4.text = fromList?[3]
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func executeResearch(_ sender: Any) {
  
        var stsJudge:Bool = true
        // 入力チェック
        stsJudge = inputCheck()
        if (stsJudge) {
            // 検索結果ラベルの削除
            self.myScrollView.subviews.forEach {
                if $0.tag == 99 {
                    $0.removeFromSuperview()
                }
            }
                
            // 検索結果生成
            createResult()
        } else {
        }
    }
    
    // 検索結果を生成
    func createResult() {
        // 登録した駅を抽出
        var toList:[String] = defaults.object(forKey: CommonValue.toListKey) as! [String]
        var bestList:[BestStationData] = []
        
        // ベストのリストを生成
        var xZiku: Int = 10
        var yZiku: Int = 15
        var rank: Int = 0
        // 駅登録の数だけ繰り返す
        for i in stride(from: 1, to: 6, by: 1) {
            // 登録がある場合
            if (!toList[i - 1].isEmpty) {
                rank += 1
                var tmpData = BestStationData()
                tmpData.bestNum = "■Best" + String(rank) + "位："
                tmpData.stationName = toList[i - 1]
                
                // ベストラベルの作成
                createLabel(xZiku: xZiku, yZiku: yZiku, content: tmpData.bestNum + tmpData.stationName, fontSize: 18)
                yZiku += 23
                // 駅1-4ラベル生成
                if (station1.text != ""
                    && station1.text != nil) {
                    
                    createLabel(xZiku: xZiku + 20, yZiku: yZiku, content: station1.text as! String + " よりXX分", fontSize: 15)
                    yZiku += 23
                }
                if (station2.text != ""
                && station2.text != nil) {                createLabel(xZiku: xZiku + 20, yZiku: yZiku, content: station2.text as! String + " よりyy分", fontSize: subFontSize)
                    yZiku += 23
                }
                if (station3.text != ""
                && station3.text != nil) {                createLabel(xZiku: xZiku + 20, yZiku: yZiku, content: station3.text as! String + " よりyy分", fontSize: subFontSize)
                    yZiku += 23
                }
                if (station4.text != ""
                && station4.text != nil) {
                createLabel(xZiku: xZiku + 20, yZiku: yZiku, content: station4.text as! String + " よりyy分", fontSize: subFontSize)
                    yZiku += 20
                }
                bestList.append(tmpData)
                // ベスト情報の間隔
                yZiku += 30
            }
        }
        getTransferGuide(fromStation: "", toStation: "")

    }
    
    // ラベルを生成する
    func createLabel(xZiku: Int,yZiku: Int, content: String, fontSize: Int) {
        let titleLabel = UILabel() // ラベルの生成
        titleLabel.frame = CGRect(x: xZiku, y: yZiku, width: 350, height: 44) // 位置とサイズの指定
        titleLabel.textAlignment = NSTextAlignment.left // 横揃えの設定
        titleLabel.text = content // テキストの設定
        titleLabel.textColor = UIColor.black // テキストカラーの設定
        titleLabel.font = UIFont(name: "HiraKakuProN-W6", size: CGFloat(fontSize))
        
        titleLabel.tag = 99
        // フォントの設定
        myScrollView.addSubview(titleLabel)
    }
    
    // 入力チェック
    func inputCheck()-> Bool {
        var toList:[String] = defaults.object(forKey: CommonValue.toListKey) as! [String]
        // 登録駅チェック
        if (toList[0].isEmpty && toList[1].isEmpty && toList[2].isEmpty && toList[3].isEmpty && toList[4].isEmpty) {
            creteDialog(setMessage: CommonValue.msg_0001)
            return false
        }
        
        // 駅1-4が未入力
        if (station1.text?.isEmpty as! Bool && station2.text?.isEmpty as! Bool && station3.text?.isEmpty as! Bool && station1.text?.isEmpty as! Bool) {
            creteDialog(setMessage: CommonValue.msg_0002)
            return false
        }
        return true
    }
    
    // Menuに戻った時の処理
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController is ViewController {
            var fromList:[String] = []
            fromList.append(station1.text as! String)
            fromList.append(station2.text as! String)
            fromList.append(station3.text as! String)
            fromList.append(station4.text as! String)
            defaults.set(fromList, forKey: "fromList")
        }
    }
    // ダイアログを生成
    func creteDialog(setMessage: String) {
        // ダイアログ
          let dialog = UIAlertController(title: "警告", message: setMessage, preferredStyle: .alert)
          dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // 生成したダイアログを実際に表示します
        self.present(dialog, animated: true, completion: nil)
    }
    
    // フォーカスがあたった際に呼び出されるメソッド.
    func textFieldDidBeginEditing (_ textField: UITextField) {
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        defaults.set(String(textField.tag), forKey: CommonValue.stationNoKey)
        
        let mode: String = CommonValue.findMode
        // 画面遷移
        self.performSegue(withIdentifier: "toAutoComplete", sender: mode)
    }
    
    //Segueの初期化を通知するメソッドをオーバーライドする。senderにはperformSegue()で渡した値が入る。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAutoComplete" {
            let autoCompleteViewController = segue.destination as! AutoCompleteViewController
            autoCompleteViewController.mode = sender as! String
        }
    }
    
    //画面遷移から戻ってきたときに実行する関数
    override func viewWillAppear(_ animated: Bool) {
        
        if (flgViewDidLoad != 0) {
            // 前回値の復元
            var fromList:[String]? = defaults.object(forKey: CommonValue.fromListKey) as! [String]?
            if (fromList != nil) {
                station1.text = fromList?[0]
                station2.text = fromList?[1]
                station3.text = fromList?[2]
                station4.text = fromList?[3]

            }
        }
        
    }
    
    public func getTransferGuide(fromStation: String, toStation: String) {
        
        // 呼び出しURL
        let apiUrl: URL = URL(string: "http://api.ekispert.jp/v1/json/search/course/light?key=" + CommonValue.accessKey +  "&from=22828&to=25853")!

        let task =  URLSession.shared.dataTask(with: apiUrl) { data, response, error in

            // ここのエラーはクライアントサイドのエラー(ホストに接続できないなど)
                 if let error = error {
                     print("クライアントエラー: \(error.localizedDescription) \n")
                     return
                 }

                 guard let data = data, let response = response as? HTTPURLResponse else {
                     print("no data or no response")
                     return
                 }
                 
                 if response.statusCode == 200 {

                    let decoder = JSONDecoder()
                     let transitInfo: TransitInfoData? = try? decoder.decode(TransitInfoData.self, from: data)

                 } else {
                     // レスポンスのステータスコードが200でない場合などはサーバサイドエラー
                     print("サーバエラー ステータスコード: \(response.statusCode)\n")
                 }

        }
              
        task.resume()
    }
    
    @IBAction func clearFrom1(_ sender: Any) {
        station1.text = ""
        var fromList:[String]? = defaults.object(forKey: CommonValue.fromListKey) as! [String]?
        if (fromList != nil) {
            fromList?[0] = ""
            defaults.set(fromList, forKey: CommonValue.fromListKey)
        }
    }
    
    @IBAction func clearFrom2(_ sender: Any) {
        station2.text = ""
        var fromList:[String]? = defaults.object(forKey: CommonValue.fromListKey) as! [String]?
        if (fromList != nil) {
            fromList?[1] = ""
            defaults.set(fromList, forKey: CommonValue.fromListKey)
                 defaults.set(fromList, forKey: CommonValue.fromListKey)
        }
       }
    
    @IBAction func clearFrom3(_ sender: Any) {
        station3.text = ""
        var fromList:[String]? = defaults.object(forKey: CommonValue.fromListKey) as! [String]?
        if (fromList != nil) {
            fromList?[2] = ""
            defaults.set(fromList, forKey: CommonValue.fromListKey)
            defaults.set(fromList, forKey: CommonValue.fromListKey)
        }
    }
    
    @IBAction func clearFrom4(_ sender: Any) {
        station4.text = ""
        var fromList:[String]? = defaults.object(forKey: CommonValue.fromListKey) as! [String]?
        if (fromList != nil) {
            fromList?[3] = ""
            defaults.set(fromList, forKey: CommonValue.fromListKey)
            defaults.set(fromList, forKey: CommonValue.fromListKey)
        }
    }
    
    @IBAction func allFromClear(_ sender: Any) {
        station1.text = ""
        station2.text = ""
        station3.text = ""
        station4.text = ""
        var fromList:[String]? = defaults.object(forKey: CommonValue.fromListKey) as! [String]?
                
        if (fromList != nil) {
            for tmp in 0...3 {
                fromList?[tmp] = ""
            }
            defaults.set(fromList, forKey: CommonValue.fromListKey)
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

