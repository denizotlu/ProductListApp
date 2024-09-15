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
    
    
    private var filteredProducts: [Product] = []
    private var isSearching = false


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchProducts()
        

    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        searchBar.placeholder = "Ürün Ara"
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.showsCancelButton = true
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemPink
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
        // Arama yapılıyorsa filtrelenmiş ürünleri göster
               return isSearching ? filteredProducts.count : products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        
        // Arama yapılıyorsa filtrelenmiş ürünleri, yoksa tüm ürünleri göster
        let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
        
        cell.titleLabel.text = product.title
        cell.priceLabel.text = "\(product.price) TL"
        
        
        let url = URL(string: product.thumbnail)
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error != nil {
                print("error")
                
            }else{
                if data != nil  {
                    
                    let image = UIImage(data: data!)
                    
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data!)
                    }
                }
                
            }
            
        }.resume()
        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}




extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Arama çubuğu boşsa tüm ürünleri göster
            isSearching = false

        } else {
            // Arama metnine göre ürünleri filtrele
            isSearching = true
            filteredProducts = products.filter {$0.title.lowercased().contains(searchText.lowercased())}
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Arama iptal edildiğinde tüm ürünleri göster
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder() //Klavye gizle
        collectionView.reloadData()
    }
    
    
    
    
}


extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]

        let detailVC = DetailViewController()
        detailVC.product = product // Seçilen ürünü detay sayfasına geçir
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


#Preview{
    ViewController()
}
