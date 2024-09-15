//
//  HomeCollectionViewCell.swift
//  ProductListApp
//
//  Created by Deniz Otlu on 9.09.2024.
//

import UIKit
import SnapKit

class HomeCollectionViewCell: UICollectionViewCell {
   
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel() 

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentView.snp.height).multipliedBy(0.7)
        }

        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.backgroundColor = .blue
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
        }

        // Fiyat etiketini ekleme
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = .black
        priceLabel.backgroundColor = .brown
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

