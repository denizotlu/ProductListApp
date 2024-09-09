//
//  ViewController.swift
//  ProductListApp
//
//  Created by Deniz Otlu on 9.09.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var collectionView : UICollectionView!
    private let searchBar = UISearchBar()
    
    private var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchProducts()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        searchBar.placeholder = "Ürün Ara"
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(10)
        }
    }

    private func fetchProducts() {
        let url = URL(string: "https://dummyjson.com/products")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Ürünleri çekerken bir hata oluştu: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                let productResponse = try JSONDecoder().decode(ProductsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.products = productResponse.products
                    self.collectionView.reloadData()
                }
            } catch {
                print("JSON çözümleme hatası: \(error.localizedDescription)")
            }
        }
        task.resume() 
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        let product = products[indexPath.row]
        
        cell.titleLabel.text = product.title
        cell.priceLabel.text = "\(product.price) TL"
        
        if let url = URL(string: product.thumbnail) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}


#Preview{
    ViewController()
}
