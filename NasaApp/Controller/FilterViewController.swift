//
//  FilterViewController.swift
//  NasaApp
//
//  Created by Ertürk Alan on 11.02.2023.
//

import Foundation
import UIKit


class FilterViewController: UIViewController {
    
    let tableView = UITableView()
    var callback: ((String) -> Void)?
    
    let filterArray = [CamFilter.rhaz.rawValue,
                       CamFilter.fhaz.rawValue,
                       CamFilter.mast.rawValue,
                       CamFilter.navcam.rawValue,
                       CamFilter.pancam.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

    }
}

//MARK: - TableView Data Source and Delegate Moethods

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = filterArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        callback!(filterArray[indexPath.row])
        dismiss(animated: true)
    }
    
}


