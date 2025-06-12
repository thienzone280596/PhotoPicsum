//
//  PhotoTableViewCell.swift
//  PhotoPicsum
//
//  Created by ThienTran on 11/6/25.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
  static let identifier = "PhotoTableViewCell"

  @IBOutlet weak var photo: UIImageView!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var imageSizeLabel: UILabel!

  internal var aspectConstraint: NSLayoutConstraint? {
      didSet {
          if oldValue != nil {
              photo.removeConstraint(oldValue!)
          }
          if aspectConstraint != nil {
              photo.addConstraint(aspectConstraint!)
          }
      }
  }

  override func prepareForReuse() {
      super.prepareForReuse()
      aspectConstraint = nil
  }

  override func awakeFromNib() {
      super.awakeFromNib()
      photo.contentMode = .scaleAspectFill
      photo.clipsToBounds = true
      photo.translatesAutoresizingMaskIntoConstraints = false
  }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
   // MARK: - Config Photo
  func configure(with data: PhotoEntity) {
      authorLabel.text = data.author
      imageSizeLabel.text = data.sizeDescription

      /// Make sure that image fit with screen and not be distorted
      if let constraint = (photo.constraints.first { $0.firstAttribute == .height }) {
          constraint.isActive = false
      }
      let aspectRatioConstraint = photo.heightAnchor.constraint(equalTo: photo.widthAnchor, multiplier: data.aspectRatio)
      aspectRatioConstraint.isActive = true

       /// Caching Image
      self.photo.loadImageUsingCache(withUrl: data.download_url)
  }

}
