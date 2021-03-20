//
//  DetailViewController.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import UIKit
import RxSwift
import FirebaseStorage
import SkeletonView

class DetailViewController: UIViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    var id: String = "0"
    var viewModel = DetailViewModel()
    private let disposable = DisposeBag()
    var data: DetailModel?
    var isLoading = true
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        btnCheckout.backgroundColor = .blue
        btnCheckout.cornerRadius = 8
        loadingIndicatorView.isHidden = true
        uploadImageView.isHidden = true
        DispatchQueue.global(qos: .background).async {
            self.viewModel.getDetailGames(id: self.id)
        }
        
        DispatchQueue.main.async {
            self.productImageView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .clouds), transition: .crossDissolve(0.25))
            self.titleLabel.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .clouds), transition: .crossDissolve(0.25))
            self.priceLabel.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .clouds), transition: .crossDissolve(0.25))
        }
    }
    
    private func initViewModel(){
        viewModel.isLoading.observe(disposable) { (data) in
            guard let isLoading = data else { return }
            self.isLoading = isLoading
            if isLoading {
                DispatchQueue.main.async {
                    self.loadingIndicatorView.isHidden = false
                    self.loadingIndicatorView.startAnimating()
                    self.btnCheckout.setTitle("", for: .normal)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.loadingIndicatorView.isHidden = true
                    self.btnCheckout.setTitle("Checkout", for: .normal)
                }
            }
        }
        
        viewModel.data.observe(disposable) { (data) in
            guard let data = data else { return }
            self.data = data
            DispatchQueue.main.async {
                self.productImageView.hideSkeleton(transition: .crossDissolve(0.25))
                self.priceLabel.hideSkeleton(transition: .crossDissolve(0.25))
                self.titleLabel.hideSkeleton(transition: .crossDissolve(0.25))
                
                self.productImageView.kf.setImage(with: data.info?.thumb?.toUrl)
                self.titleLabel.text = "Title: \n\(data.info?.title ?? "")"
                self.priceLabel.text = "Price: $\(data.cheapestPriceEver?.price ?? "")"
            }
        }
    }
    
    @IBAction func onCheckout(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        viewModel.isLoading.value = true
        present(picker, animated: true, completion: nil)
    }
    
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        viewModel.isLoading.value = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData(), let data = self.data else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let ref = storage.child("image/file.jpg")
        ref.putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("upload failed")
                return
            }
            DispatchQueue.main.async {
                self.showToast(message: "Upload Success", font: .systemFont(ofSize: 20))
            }
            self.viewModel.uploadUserData(data: data)
            self.storage.child("image/file.jpg").downloadURL(completion: {url, error in
                guard let url = url, error == nil else { return }
                let urlString = url.absoluteString
            })
        })
    }
}
