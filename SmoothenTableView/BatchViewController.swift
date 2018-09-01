//
//  BatchViewController.swift
//  SmoothenTableView
//
//  Created by MINATO on 9/1/18.
//  Copyright © 2018 MINATO. All rights reserved.
//

import UIKit

class BatchViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var coinTableView: UITableView!
    
    let coinCellIdentifier = String(describing: CoinTableViewCell.self)
    
    var coinArray: [CoinElement] = []
    
    let baseURL = "https://api.coinmarketcap.com/v2/ticker/?"
    
    // fetch 15 items for each batch
    let itemsPerBatch = 25
    
    // current row from database
    var currentRow : Int = 1
    
    // URL computed by current row
    var url: URL {
        return URL(string: "\(baseURL)start=\(currentRow)&limit=\(itemsPerBatch)")!
    }
    
    // ... skipped viewDidLoad stuff
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 64)
        return spinner
    }()
    
    func addSpinnerIntoFooterTableView() {
        coinTableView.tableFooterView = spinner
        coinTableView.tableFooterView?.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load first
        addSpinnerIntoFooterTableView()
        loadNextBatch()
    }
    
    // MARK : - Tableview data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // +1 to show the loading cell at the last row
        return coinArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        coinTableView.tableFooterView?.isHidden = true
        
        // else show the cell as usual
        let cell = tableView.dequeueReusableCell(withIdentifier: coinCellIdentifier , for: indexPath)
        
        // get the corresponding post object to show from the array
        if let coinCell = cell as? CoinTableViewCell, indexPath.row < coinArray.count {
            let coin = coinArray[indexPath.row]
            coinCell.configureCell(with: coin)
        }
        
        // if reached last row, load next batch
        if indexPath.row == coinArray.count - 1 {
            addSpinnerIntoFooterTableView()
            loadNextBatch()
        }
        
        return cell
    }
    
    // MARK : - Batch
    func loadNextBatch() {
        URLSession(configuration: URLSessionConfiguration.default)
            .dataTask(with: url) { data, response, error in
                
                // Parse JSON into array of Car struct using JSONDecoder
                guard let coinList = try? JSONDecoder().decode(Coins.self, from: data!) else {
                    print("Error: Couldn't decode data into coin list")
                    return
                }
                
                // contain array of tuples, ie. [(key : ID, value : Coin)]
                let coinTupleArray = coinList.data?.sorted {$0.value.rank! < $1.value.rank!}
                for coinTuple in coinTupleArray! {
                    self.coinArray.append(coinTuple.value)
                }
                
                // increment current row
                self.currentRow += self.itemsPerBatch
                
                // Make sure to update UI in main thread
                DispatchQueue.main.async {
                    self.coinTableView.reloadData()
                }
            }
            .resume()
    }
    
}
