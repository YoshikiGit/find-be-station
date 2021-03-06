//
//  AutoCompleteViewController.swift
//  FindBeStation
//
//  Created by 佐藤利紀 on 2019/12/06.
//  Copyright © 2019 Yoshiki Sato. All rights reserved.
//

import UIKit

class AutoCompleteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating,UINavigationControllerDelegate  {
    
    var PPAP:Array<String> = []
    var searchResults:[String] = []
    var tableView: UITableView!
    var searchController = UISearchController()
    let defaults = UserDefaults.standard
    var mode:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: self.view.frame.width, height: self.view.frame.height))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.allowsSelection = true
        self.view.addSubview(tableView)

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return PPAP.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        if searchController.isActive {
            cell.textLabel!.text = "\(searchResults[indexPath.row])"
        } else {
            cell.textLabel!.text = "\(PPAP[indexPath.row])"
        }

        return cell
    }

    // 文字が入力される度に呼ばれる
    func updateSearchResults(for searchController: UISearchController) {
        self.searchResults = []
        var searchWord: String = searchController.searchBar.text!
        
        if (searchWord.utf8.count >= 2) {
            getTransferGuide(searchWord: searchWord)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                self.searchResults = self.PPAP.filter{      $0.contains(self.searchController.searchBar.text!)
                        }
               self.tableView.reloadData()
            }
        }
    }
    
    //セルが選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)
        let stationName: String = String((cell?.textLabel!.text)!)
        
        // 遷移元画面によって処理を分岐
        if (mode == CommonValue.regMode) {
            
                doRegAutoComp(stationName: stationName)
        } else if (mode == CommonValue.findMode) {
            doFindAutoComp(stationName: stationName)
        }
        
            // 画面遷移
    self.navigationController?.popViewController(animated: true)
    }
    
    // 駅登録画面から遷移した場合
    private func doRegAutoComp(stationName: String) {
        // 前画面のテキストフィールドの識別
        var stationNo:String = defaults.object(forKey: CommonValue.stationNoKey) as! String
         
        var toList:[String]? = defaults.object(forKey: CommonValue.toListKey) as! [String]?

        if (toList == nil) {
            toList = ["","","","",""]
        }
        if (stationNo == "0") {
            toList?[0] = stationName
         } else if(stationNo == "1") {
             toList?[1] = stationName
         } else if(stationNo == "2") {
            toList?[2] = stationName
         } else if(stationNo == "3") {
            toList?[3] = stationName
         } else if(stationNo == "4") {
            toList?[4] = stationName
         }
        defaults.set(toList, forKey: CommonValue.toListKey)
    }
    
    private func doFindAutoComp(stationName: String) {
        // 前画面のテキストフィールドの識別
        var stationNo:String = defaults.object(forKey: CommonValue.stationNoKey) as! String
          
        var fromList:[String]? = defaults.object(forKey: CommonValue.fromListKey) as! [String]?
        
        // 存在しなければインスタンス
        if (fromList == nil) {
            fromList = ["","","",""]
        }
        if (stationNo == "0") {
           fromList?[0] = stationName
        } else if(stationNo == "1") {
           fromList?[1] = stationName
        } else if(stationNo == "2") {
           fromList?[2] = stationName
        } else if(stationNo == "3") {
           fromList?[3] = stationName
        }
        defaults.set(fromList, forKey: CommonValue.fromListKey)
    }
    
    public func getTransferGuide(searchWord: String) {
         
        let apiUrl = "http://api.ekispert.jp/v1/json/station?name=" + searchWord + "&type=train&offset=1&limit=10&direction=up&gcs=tokyo&key=" + CommonValue.accessKey
        
        let encodeUrlString: String! = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
         // 呼び出しURL
        let url: URL = URL(string: encodeUrlString)!

         let task =  URLSession.shared.dataTask(with: url) { data, response, error in

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
                    print(data)
                     let transitInfo: TransitInfoData? = try? decoder.decode(TransitInfoData.self, from: data)
                    
                    var resArray: Array<String> = []
                    if (transitInfo != nil) {
                        for cmpData in (transitInfo?.ResultSet.Point)! {
                            resArray.append( cmpData.Station.Name)
                        }
                        self.PPAP = resArray

                    }
                    
                  } else {
                      // レスポンスのステータスコードが200でない場合などはサーバサイドエラー
                      print("サーバエラー ステータスコード: \(response.statusCode)\n")
                  }

         }
               
         task.resume()
     }
    
    // 戻った時の処理
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        // サーチバーの削除
        self.definesPresentationContext = true
    
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
