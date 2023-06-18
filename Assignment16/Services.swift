//
//  PostsService.swift
//  Assignment16
//
//  Created by macbook  on 17.06.23.
//

import Foundation

class DataService {
    static let postsUrl = "https://jsonplaceholder.typicode.com/posts"
    
    public static var shared = DataService()
    
    //Private initializer
    private init() {
        
    }
    
    func getComments(
        postID: Int,
        completion: @escaping ([CommentModel]) -> Void,
        onError: @escaping () -> Void)
    {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postID)/comments") {
            getData(from: url, completion: completion, onError: onError)
        } else {
            onError()
        }
    }
    
    func getPosts(completion: @escaping ([PostModel]) -> Void, onError: @escaping () -> Void) {
        if let url = URL(string: DataService.postsUrl) {
            getData(from: url, completion: completion, onError: onError)
        } else {
            onError()
        }
    }
    
    private func getData<T: Codable>(
        from url: URL,
        completion: @escaping (T)-> Void,
        onError: @escaping () -> Void
    ) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error == nil, let data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(result)
                } catch {
                    onError()
                }
            } else {
                onError()
            }
        }.resume()
    }
}
