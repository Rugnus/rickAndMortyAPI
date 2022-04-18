//
//  CharacterTableViewCell.swift
//  RickAndMortyAPI
//
//  Created by Sungur on 17.04.2022.
//

import UIKit

class CharacterTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class CharacterTableViewCell: UITableViewCell {

    
    static let identifier = "CharacterTableViewCell"
    
    private let characterTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(characterTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(characterImageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        characterTitleLabel.frame = CGRect(x: 10,
                                           y: 0,
                                           width: contentView.frame.size.width - 120,
                                           height: contentView.frame.size.height / 2)
        
        characterImageView.frame = CGRect(x: contentView.frame.size.width-170,
                                          y: 5,
                                          width: 160,
                                          height: contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterTitleLabel.text = nil
        characterImageView.image = nil
    }
    
    func configure(with viewModel: CharacterTableViewCellViewModel) {
        characterTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        
        if let data = viewModel.imageData {
            characterImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {return}
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.characterImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
