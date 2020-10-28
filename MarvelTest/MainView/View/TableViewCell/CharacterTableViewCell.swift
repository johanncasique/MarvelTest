//
//  CharacterTableViewCell.swift
//  MarvelTest
//
//  Created by johann casique on 26/10/20.
//

import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell {
    
    lazy var characterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var characterName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var separatorView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.alpha = 0.3
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        characterImage.layer.cornerRadius = 15
        characterImage.clipsToBounds = true
    }
    
    private func setupViews() {
        addSubview(characterImage)
        addSubview(characterName)
        addSubview(subtitleLabel)
        addSubview(separatorView)
        
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            characterImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            characterImage.heightAnchor.constraint(equalToConstant: 80),
            characterImage.widthAnchor.constraint(equalToConstant: 80),
            characterImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            characterName.leadingAnchor.constraint(equalTo: characterImage.trailingAnchor, constant: 8),
            characterName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            characterName.topAnchor.constraint(equalTo: characterImage.topAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: characterName.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: characterName.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 8),
            
            separatorView.leadingAnchor.constraint(equalTo: characterName.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configureView(with viewModel: CharacterTableViewCellViewModel?) {
        characterName.text = viewModel?.name
        subtitleLabel.text = viewModel?.description
        characterImage.kf.indicatorType = .activity
        characterImage.kf.setImage(with: viewModel?.imageURL)
    }
}


