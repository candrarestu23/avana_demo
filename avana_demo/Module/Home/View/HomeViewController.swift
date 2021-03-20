//
//  HomeViewController.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import UIKit
import RxSwift
import Kingfisher
import SkeletonView
import FBSDKLoginKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = HomeViewModel()
    private let disposable = DisposeBag()
    var data: [HomeModel] = []
    var pages: Int = 1
    var isLoading = true
    lazy var logouBtn:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        initViewModel()
        setupNavButton()
        navigationItem.title = "Home"
        DispatchQueue.global(qos: .background).async {
            self.viewModel.getGames(storeId: 1, pageNumber: 1, pageSize: 10, upperPrice: 50)
        }
    }

    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: HomeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.identifier)
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.center = footer.center
        footer.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        tableView.tableFooterView = footer
    }
    
    private func setupNavButton(){
        logouBtn.setTitle("Logout", for: .normal)
        logouBtn.setTitleColor(.blue, for: .normal)
        logouBtn.addTarget(self, action: #selector(self.logoutClicked), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView:logouBtn)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func logoutClicked(){
        LoginManager().logOut()
        let viewController = UINavigationController(rootViewController: LoginViewController())
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        self.navigationController?.popToRootViewController(animated: true)
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
        return self.isLoading == true ? 8 : data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier) as? HomeTableViewCell else { return UITableViewCell() }
        
        if self.isLoading {
            cell.productImageView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .clouds), transition: .crossDissolve(0.25))
            cell.ratingLabel.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .clouds), transition: .crossDissolve(0.25))
            cell.titleLabel.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .clouds), transition: .crossDissolve(0.25))
            cell.dateLabel.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .clouds), transition: .crossDissolve(0.25))
            cell.PriceLabel.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .clouds), transition: .crossDissolve(0.25))
        } else {
            cell.productImageView.hideSkeleton(transition: .crossDissolve(0.25))
            cell.ratingLabel.hideSkeleton(transition: .crossDissolve(0.25))
            cell.titleLabel.hideSkeleton(transition: .crossDissolve(0.25))
            cell.dateLabel.hideSkeleton(transition: .crossDissolve(0.25))
            cell.PriceLabel.hideSkeleton(transition: .crossDissolve(0.25))
        }
        
        if self.data.count > 0 {
            let data = self.data[indexPath.row]
            cell.productImageView.kf.setImage(with: data.thumb?.toUrl)
            cell.ratingLabel.text = "Rating: \(data.steamRatingPercent ?? "")"
            cell.titleLabel.text = data.title ?? ""
            cell.dateLabel.text = data.releaseDate?.dateFromInt()
            cell.PriceLabel.text = "$\(data.normalPrice ?? "")"
        }

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
