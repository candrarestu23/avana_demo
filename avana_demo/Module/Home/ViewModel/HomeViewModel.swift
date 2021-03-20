//
//  HomeViewModel.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation
import Moya
import RxSwift

class HomeViewModel{
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<HomeService>()
    let data = ObservableData<[HomeModel]>()
    let isLoading = ObservableData<Bool>()
    let errorMessage = ObservableData<String>()
    
    func getGames(storeId: Int, pageNumber: Int, pageSize: Int, upperPrice: Int) {
        isLoading.value = true
        provider.rx.request(.getHomeData(storeId, pageNumber, pageSize, upperPrice))
            .map([HomeModel].self)
            .subscribe { [weak self] (event) in
                self?.isLoading.value = false
                switch event {
                case .success(let response):
                    self?.data.value = response
                case .error(let error):
                    print(error.localizedDescription)
                }
        }.disposed(by: disposeBag)
    }
}

