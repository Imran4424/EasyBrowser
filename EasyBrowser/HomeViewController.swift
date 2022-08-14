//
//  HomeViewController.swift
//  EasyBrowser
//
//  Created by Shah Md Imran Hossain on 13/8/22.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var websites = ["apple.com", "shahcodersden.com", "hackingwithswift.com", "google.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadWebsite(url: String) {
        let workUrl = "https://" + url
        
        guard let basicWebViewController = storyboard?.instantiateViewController(withIdentifier: "basicWeb") as? BasicWebViewController else {
            print("[HomeViewController] basic web view is not initiated")
            return
        }
        
        basicWebViewController.urlString = workUrl
        // navigation controller for destination view controller
        let navController = UINavigationController(rootViewController: basicWebViewController)
        
        // here modal will be navigation controller
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}

// MARK: - Table View Data Source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            print("Failed to deque cell")
            return UITableViewCell()
        }
        
        cell.label.text = websites[indexPath.row]
        
        return cell
    }
    
    
}

// MARK: - Table View Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadWebsite(url: websites[indexPath.row])
    }
}

// MARK: - Table View Cell
class TableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
}

// MARK: - String extention
extension String {
    // validating url
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
