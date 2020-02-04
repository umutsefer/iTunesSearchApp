//
//  SelectionPopupVC.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 11.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import UIKit

class SelectionPopupVC: BaseVC {

    /// Filter options.
    let options = [AppStrings.movie.rawValue, AppStrings.podcast.rawValue, AppStrings.music.rawValue, AppStrings.all.rawValue]
    let cellId = "reuseIdentifier"
    let si_unwindToHome = "SI_UndwindToHome"
    
    /// Sets from HomeVC to add check mark which item selected already to filter.
    var selectedRowValue: String = AppStrings.all.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        navigationType = .rightDone
    }
    
    override func rightButtonClicked(sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: si_unwindToHome, sender: nil)
    }
}

extension SelectionPopupVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let value = options[indexPath.row]
        cell.textLabel?.text = value
        cell.selectionStyle = .none
        if selectedRowValue == value {
            cell.accessoryType = .checkmark
        } else
        {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

extension SelectionPopupVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowValue = options[indexPath.row]
        tableView.reloadData()
    }
}
