//
//  ViewController.swift
//  Project7
//
//  Created by Александр Банников on 30.07.2020.
//  Copyright © 2020 Александр Банников. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var searchResult = [Petition]()
    var activeSearch = false {
        didSet {
            DispatchQueue.main.async {
                //self.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.showCredits))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(self.userSearch))
        }
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
//        let urlString: String
//
//        if navigationController?.tabBarItem.tag == 0 {
//            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
//        } else {
//            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
//        }
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                //self.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
                self.tableView.reloadData()
            }
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        activeSearch = false
    //    }
    
    @objc func userSearch() {
        activeSearch = false
//        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        let ac = UIAlertController(title: "Search for petitions", message: "Type search request", preferredStyle: .alert)
        ac.addTextField()
        let query = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] action in
            guard let search = ac?.textFields?[0].text else { return }
            self?.performSelector(inBackground: #selector(self?.submit), with: search)
            //self?.submit(search)
        }
        
        ac.addAction(query)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
        
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Hey!", message: "This data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Nice!", style: .default))
        present(ac, animated: true)
        activeSearch = false
    //    tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !activeSearch { return petitions.count } else { return searchResult.count }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition : Petition
        if !activeSearch {
            petition = petitions[indexPath.row]
        } else {
            petition = searchResult[indexPath.row]
        }
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let vc = DetailViewController()
            vc.detailItem = self.petitions[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func submit(_ search: String){
        
        print(search)
        for result in petitions {
            if result.title.contains(search) || result.body.contains(search) {
                searchResult.append(result)
            }
        }
        let dpt = petitions
        print(searchResult)
        petitions = searchResult
        activeSearch = true
        
        //activeSearch = false
        petitions = dpt
    }
}

