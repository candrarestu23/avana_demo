//
//  DetailViewModel.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation
import Moya
import RxSwift
import Firebase

class DetailViewModel{
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<HomeService>()
    let data = ObservableData<DetailModel>()
    let isLoading = ObservableData<Bool>()
    let errorMessage = ObservableData<String>()
    
    func getDetailGames(id: String) {
        isLoading.value = true
        provider.rx.request(.getDetail(Int(id) ?? 0))
            .map(DetailModel.self)
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
    
    func uploadUserData(){
        let db = FireStore
    }
}
