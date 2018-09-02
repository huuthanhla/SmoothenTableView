//
//  NewsViewController.swift
//  SmoothenTableView
//
//  Created by MINATO on 9/2/18.
//  Copyright © 2018 MINATO. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    
    let newsCellIdentifier = String(describing: CoinTableViewCell.self)

    var newsIDs = [17549050, 17549099, 17548768, 17546915, 17534858]
    
    
    // this is the data source for table view
    // fill the array with 100 nil first, then replace the nil with the loaded news object at its corresponding index/position
    var newsArray: [News?] = [News?](repeating: nil, count: 100)
    
    // store task (calling API) of getting each news
    var dataTasks : [URLSessionDataTask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        (1...4).forEach { _ in newsIDs += newsIDs }
//        newsArray = [News?](repeating: nil, count: newsIDs.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // the 'index' parameter indicates the row index of tableview
    // we will fetch and show the correspond news data for that row
    func fetchNews(ofIndex index: Int) {
        guard index < newsIDs.count else { return }
        let newsID = newsIDs[index]
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(newsID).json")!
        
        // if there is already an existing data task for that specific news url, it means we already loaded it previously / currently loading it
        // stop re-downloading it by returning this function
        if dataTasks.index(where: { task in task.originalRequest?.url == url }) != nil {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data")
                return
            }
            
            // Parse JSON into array of Car struct using JSONDecoder
            guard let news = try? JSONDecoder().decode(News.self, from: data) else {
                print("Error: Couldn't decode data into news")
                return
            }
            
            // replace the initial 'nil' value with the loaded news
            // to indicate that the news have been loaded for the table view
            self.newsArray[index] = news
            
            // Update UI on main thread
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: 0)
                // check if the row of news which we are calling API to retrieve is in the visible rows area in screen
                // the 'indexPathsForVisibleRows?' is because indexPathsForVisibleRows might return nil when there is no rows in visible area/screen
                // if the indexPathsForVisibleRows is nil, '?? false' will make it become false
                if self.newsTableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                    // if the row is visible (means it is currently empty on screen, refresh it with the loaded data with fade animation
                    self.newsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                }
            }
        }
        
        // run the task of fetching news, and append it to the dataTasks array
        dataTask.resume()
        dataTasks.append(dataTask)
    }
    
    // the 'index' parameter indicates the row index of tableview
    func cancelFetchNews(ofIndex index: Int) {
        guard index < newsIDs.count else { return }
        let newsID = newsIDs[index]
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(newsID).json")!
        
        // get the index of the dataTask which load this specific news
        // if there is no existing data task for the specific news, no need to cancel it
        guard let dataTaskIndex = dataTasks.index(where: { task in
            task.originalRequest?.url == url
        }) else {
            return
        }
        
        let dataTask =  dataTasks[dataTaskIndex]
        
        // cancel and remove the dataTask from the dataTasks array
        // so that a new datatask will be created and used to load news next time
        // since we already cancelled it before it has finished loading
        dataTask.cancel()
        dataTasks.remove(at: dataTaskIndex)
        
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableViewCell.self), for: indexPath)
        
        guard let newCell = cell as? NewsTableViewCell else { return cell }
        
        if let news = newsArray[indexPath.row] {
            newCell.configure(with: news)
        } else {
            // if the news havent loaded (nil havent got replaced), reset all the label
            newCell.truncateCell()
            
            // fetch the news from API
            self.fetchNews(ofIndex: indexPath.row)
        }
        
        return cell
    }
}

extension NewsViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        // fetch News from API for those rows that are being prefetched (near to visible area)
        for indexPath in indexPaths {
            self.fetchNews(ofIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        // cancel the task of fetching news from API when user scroll away from them
        for indexPath in indexPaths {
            self.cancelFetchNews(ofIndex: indexPath.row)
        }
    }
}
