//
//  DetailViewModel.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import Foundation
import Moya
import RxSwift
import FirebaseFirestore
import FirebaseAuth

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
    
    func uploadUserData(data: DetailModel){
        guard let user = Auth.auth().currentUser else {
            print("user not found")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").addDocument(data: [
            "uid" : user.uid,
            "name" : user.displayName,
            "email": user.email,
            "phone" : user.phoneNumber,
            "gameId" : data.info?.steamAppId,
            "gameName" : data.info?.title,
            "gamePrice" : data.cheapestPriceEver?.price
        ]) { error in
            self.isLoading.value = false
            if let error = error {
                print("Error Adding Document: \(error)")
            } else {
                print("Document Added to firestore")
            }
            
        }
    }
}
