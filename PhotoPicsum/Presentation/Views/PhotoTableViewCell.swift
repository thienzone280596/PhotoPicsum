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
    // Delete old constraint
      aspectConstraint?.isActive = false
    // Add new ratio constraint according to aspect ratio
      let aspect = data.aspectRatio
      let newConstraint = photo.heightAnchor.constraint(equalTo: photo.widthAnchor, multiplier: aspect)
      newConstraint.priority = .required
      newConstraint.isActive = true
      aspectConstraint = newConstraint
    // Load image from URL (with cache)
      self.photo.loadImageUsingCache(withUrl: data.download_url)
  }


}
