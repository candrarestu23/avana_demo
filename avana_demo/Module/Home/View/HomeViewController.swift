//
//  HomeViewController.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import UIKit
import RxSwift
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = HomeViewModel()
    private let disposable = DisposeBag()
    var data: [HomeModel] = []
    var pages: Int = 1
    var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        initViewModel()
        navigationItem.title = "Home"
        DispatchQueue.global(qos: .background).async {
            self.viewModel.getGames(storeId: 1, pageNumber: 1, pageSize: 10, upperPrice: 50)
        }
    }

    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: HomeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.identifier)
    }
    
    private func initViewModel(){
        viewModel.isLoading.observe(disposable) { (data) in
            guard let isLoading = data else { return }
            self.isLoading = isLoading
        }
        
        viewModel.data.observe(disposable) { (data) in
            guard let data = data else { return }
            self.data.append(contentsOf: data)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier) as? HomeTableViewCell else { return UITableViewCell() }
        let data = self.data[indexPath.row]
        cell.productImageView.kf.setImage(with: data.thumb?.toUrl)
        cell.ratingLabel.text = "Rating: \(data.steamRatingPercent ?? "")"
        cell.titleLabel.text = data.title ?? ""
        cell.dateLabel.text = data.releaseDate?.dateFromInt()
        cell.PriceLabel.text = "$\(data.normalPrice ?? "")"
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        viewController.id = self.data[indexPath.row].gameID ?? ""
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let isReachingEnd = scrollView.contentOffset.y >= 0
          && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)

        if isReachingEnd && !isLoading && self.data.count >= 10 {
            DispatchQueue.global(qos: .background).async {
                self.pages += 1
                self.viewModel.getGames(storeId: 1, pageNumber: self.pages, pageSize: 10, upperPrice: 50)
            }
        }
    }
}
