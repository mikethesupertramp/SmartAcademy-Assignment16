//
//  DetailsVC.swift
//  Assignment16
//
//  Created by macbook  on 17.06.23.
//

import UIKit

class CommentsVC: UIViewController {
    @IBOutlet weak var commentsTableView: UITableView!
    
    var post: PostModel?
    var comments: [CommentModel] = []
    
    override func viewDidLoad() {
        guard let post else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        DataService.shared.getComments(postID: post.id) { result in
            DispatchQueue.main.async {
                self.comments = result
                self.commentsTableView.reloadData()
            }
        } onError: {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension CommentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell
        cell?.labelTitle.text = comments[indexPath.row].name
        cell?.labelBody.text = comments[indexPath.row].body
        return cell!
    }
    
    
}
