//
//  ListTableViewCell.swift
//  PhotoDiary
//
//  Created by haewon on 2024/05/14.
//

import UIKit
import SnapKit

class ListTableViewCell: UITableViewCell {

    static let identifier = "ListTableViewCell"
    
    let image = UIImageView()
    let title = UILabel()
    let contents = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCell() {
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(contents)
        
        image.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.leading.top.bottom.equalToSuperview().inset(5)
        }
        
        title.snp.makeConstraints {
            $0.leading.equalTo(image.snp.trailing).offset(10)
            $0.top.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().inset(5)
        }
        
        contents.snp.makeConstraints {
            $0.leading.equalTo(image.snp.trailing).offset(10)
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(5)
        }
    }
    
    func configureCell(_ data: PostInfo) {
        image.image = UIImage(named: data.image)
        title.text = data.title
        contents.text = data.contents
    }
    
}
