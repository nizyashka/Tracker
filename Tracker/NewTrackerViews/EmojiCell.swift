import UIKit

final class EmojiCell: UICollectionViewCell {
    let emojiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureEmojiLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureEmojiLabel() {
        emojiLabel.font = UIFont.systemFont(ofSize: 32)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
