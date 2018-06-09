//
//  DogListViewController.swift
//  DogBread
//
//  Created by Yue Shen on 6/8/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit
import SwiftyJSON

class DogListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private var tblDogBreedList: UITableView!
    private var refresher: UIRefreshControl!
    private var dogListViewModels = [DogListViewModel]()
    private var filteredDogList = [DogListViewModel]()
    
    private var searchBar: UISearchBar?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupSearchBar()
        getList()
    }

    // MARK: - UI Setups
    
    private func setupTable() {
        view.backgroundColor = .white
        title = "Dog List"
        
        tblDogBreedList = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        tblDogBreedList.delegate = self
        tblDogBreedList.dataSource = self
        tblDogBreedList.register(DogListCell.self, forCellReuseIdentifier: "DogListCell")
        tblDogBreedList.tableFooterView = UIView(frame: .zero)
        
        view.addSubview(tblDogBreedList)
        
        refresher = UIRefreshControl()
        tblDogBreedList.addSubview(refresher)
        refresher.addTarget(self, action: #selector(getList), for: .valueChanged)
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        searchBar?.placeholder = "Search a Breed"
        searchBar?.delegate = self
        tblDogBreedList.tableHeaderView = searchBar
    }
    
    // MARK: - Get Dog Breed List
    
    @objc private func getList() {
        Methods.shared.getDogList { (status, result) in
            guard status / 2 == 100 else { return }
            let list = JSON(result)
            guard list["status"].stringValue == "success" else { return }
            self.dogListViewModels.removeAll(keepingCapacity: true)
            for (key, _) in list["message"].dictionaryValue {
                let viewModel = DogListViewModel(breed: key)
                self.dogListViewModels.append(viewModel)
            }
            self.dogListViewModels = self.dogListViewModels.sorted( by: { $0.dogBreed < $1.dogBreed
            })
            self.tblDogBreedList.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    // MARK: - UISearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterInDogList(text: searchText.lowercased())
    }
    
    // MARK: - UIScrollView Delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar?.endEditing(true)
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar?.text != "" {
            return filteredDogList.count
        }
        return dogListViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogListCell", for: indexPath) as! DogListCell
        if searchBar?.text != "" {
            cell.configureCell(data: filteredDogList[indexPath.row])
        } else {
            cell.configureCell(data: dogListViewModels[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar?.endEditing(true)
        let vc = DogBreedDetailViewController()
        vc.dogListViewModel = dogListViewModels[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Auxiliaries
    private func filterInDogList(text: String) {
        filteredDogList = dogListViewModels.filter( { $0.dogBreed.contains(text) } )
        tblDogBreedList.reloadData()
    }
}

