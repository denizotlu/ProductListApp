//
//  DetailViewController.swift
//  ProductListApp
//
//  Created by Deniz Otlu on 16.09.2024.
//


import UIKit

class DetailViewController: UIViewController {

    var product: Product?

    private let productImageView = UIImageView()
    private let productTitleLabel = UILabel()
    private let productPriceLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureView()
    }
            private func setupUI() {
                view.addSubview(productImageView)
                view.addSubview(productTitleLabel)
                view.addSubview(productPriceLabel)
              

                productImageView.contentMode = .scaleAspectFit
                productTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
                productPriceLabel.font = UIFont.systemFont(ofSize: 18)
              

                productImageView.snp.makeConstraints { make in
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                    make.left.right.equalToSuperview().inset(20)
                    make.height.equalTo(200)
                }

                productTitleLabel.snp.makeConstraints { make in
                    make.top.equalTo(productImageView.snp.bottom).offset(20)
                    make.left.right.equalToSuperview().inset(20)
                }

                productPriceLabel.snp.makeConstraints { make in
                    make.top.equalTo(productTitleLabel.snp.bottom).offset(10)
                    make.left.equalToSuperview().inset(20)
                }

            }

            private func configureView() {
                guard let product = product else { return }
                
                productTitleLabel.text = product.title
                productPriceLabel.text = "\(product.price) TL"
             
                if let url = URL(string: product.thumbnail) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            DispatchQueue.main.async {
                                self.productImageView.image = UIImage(data: data)
                            }
                        }
                    }.resume()
                }
            }
        }
