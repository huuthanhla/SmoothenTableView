//
//  ViewController.swift
//  SmoothenTableView
//
//  Created by MINATO on 9/1/18.
//  Copyright © 2018 MINATO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var postTableView: UITableView!
    
    var postArray = [PostElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingAllData()
    }

    fileprivate func loadingAllData() {
        guard let postUrl = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        // Load all data (100 rows) at once
        URLSession(configuration: URLSessionConfiguration.default)
            .dataTask(with: postUrl) { data, response, error in
                // ensure there is data returned from this HTTP response
                guard let data = data else {
                    print("No data")
                    return
                }
                
                // Parse JSON into Post array struct using JSONDecoder
                guard let posts = try? JSONDecoder().decode(Post.self, from: data) else {
                    print("Error: Couldn't decode data into post model")
                    return
                }
                
                // postArray of data source
                self.postArray = posts
                
                // Make sure to update UI in main thread
                DispatchQueue.main.async {
                    self.postTableView.reloadData()
                }
            }
            .resume()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath)
        
        if let postCell = cell as? PostTableViewCell {
            postCell.configure(with: postArray[indexPath.row])
        }
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}
