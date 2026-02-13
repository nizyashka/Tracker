import UIKit

final class CategoryCell: UITableViewCell {
    let categoryNameLabel = UILabel()
    let checkmarkImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .ypGray30
        
        configureCategoryNameLabel()
        configureCheckmarkImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCategoryNameLabel() {
        categoryNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryNameLabel)
        
        categoryNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
    }
    
    private func configureCheckmarkImageView() {
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.isHidden = true
        checkmarkImageView.tintColor = .systemBlue
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkmarkImageView)
        
        checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
