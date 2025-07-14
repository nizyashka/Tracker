//
//  TrackerEditViewCell.swift
//  Tracker
//
//  Created by Алексей Непряхин on 14.07.2025.
//

import UIKit

final class TrackerEditViewCell: NewHabitViewCell {
    var trackerName: String?
    var trackerCategory1: String?
    var trackerSchedule: [String]?
    var trackerEmoji: String?
    var trackerColor: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        setProperties()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProperties() {
        trackerNameTextField.text = trackerName
    }
}

//extension TrackerEditViewCell {
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == emojiCollectionView {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCell else {
//                print("[NewTrackerViewCell] - collectionView: Unable to dequeue a cell.")
//                return UICollectionViewCell()
//            }
//            
//            cell.emojiLabel.text = emoji[indexPath.row]
//            
//            if indexPath.row == 5
//            {
//                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left) //Add this line
//                cell.isSelected = true
//            }
//            
//            return cell
//        } else if collectionView == colorCollectionView {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell else {
//                print("[NewTrackerViewCell] - collectionView: Unable to dequeue a cell.")
//                return UICollectionViewCell()
//            }
//            
//            cell.roundedColorRect.backgroundColor = UIColor(named: colorNames[indexPath.row])
//            
//            return cell
//        }
//        
//        return UICollectionViewCell()
//    }
//}
