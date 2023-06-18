//
//  ViewController.swift
//  Assignment16
//
//  Created by macbook  on 15.06.23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    var data: [(user: Int, posts: [PostModel])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        update()
    }
    
    func update() {
        loadingView.isHidden = false
        DataService.shared.getPosts(completion: postsReceived, onError: showError)
    }
    
    func postsReceived(_ posts: [PostModel]) {
        //Simulate additional delay
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            self.organizeData(posts)
            self.postsTableView.reloadData()
            self.loadingView.isHidden = true
        }
    }
    
    func showError() {
        //Simulate additional delay
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            self.loadingView.isHidden = true
            let alert = UIAlertController(
                title: "Error loading data",
                message: "Data could not be loaded from the server",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                self.update()
            })
            
            self.present(alert, animated: true)
        }
    }
    
    //Not quite sure how optimized this is
    //Taking into account a more generalized case when
    //user id's are not ordered + not all id's are preset e.g 7, 15, 2, 33
    func organizeData(_ posts: [PostModel]) {
        //Clean any previus data
        data.removeAll()
        
        //Create a temporary dictionary for storing post belonging to a certain user
        var temp: Dictionary<Int, [PostModel]> = [:]
        
        //iterate over posts and place them in the dictinary correctly
        for post in posts {
            //Get previus list of posts of a certain user
            //If it does not exist start with an empty one
            var array = temp[post.userId] ?? []
            //Add new post to the list
            array.append(post)
            //Place list back into the dictionary
            temp[post.userId] = array
        }
        
        //Translate dictionary into a data array
        for keyValue in temp {
            data.append((user: keyValue.key, posts: keyValue.value))
        }
        
        //Sort data
        data = data.sorted() {
            $0.user < $1.user
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Posts of user \(data[section].user)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
        cell?.post = data[indexPath.section].posts[indexPath.row]
        cell?.action = showComments(post:)
        return cell!
    }
    
    func showComments(post: PostModel) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as? CommentsVC
        viewController?.post = post
        navigationController?.pushViewController(viewController!, animated: true)
    }
}

