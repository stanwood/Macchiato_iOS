//
//  TableViewController.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 03/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

let identifier = "cell"

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = "cell_\(indexPath.row)"
        return cell
        
    }
}
