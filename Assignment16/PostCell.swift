//
//  PostCell.swift
//  Assignment16
//
//  Created by macbook  on 17.06.23.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    var action: ((PostModel) -> Void)?
    var post: PostModel? {
        didSet {
            titleLabel.text = post?.title
        }
    }
    
    @IBAction func showComments(_ sender: Any) {
        if let post, let action {
            action(post)
        }
    }
}
