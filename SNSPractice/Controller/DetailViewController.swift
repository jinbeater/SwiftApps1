//
//  DetailViewController.swift
//  SNSPractice
//
//  Created by あかにしらぶお on 2021/09/16.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    var userName = String()
    var profileImageString = String()
    var contentImageString = String()
    var comment = String()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = 50
        userNameLabel.text = userName
        contentImageView.sd_setImage(with: URL(string: contentImageString), completed: nil)
        profileImageView.sd_setImage(with: URL(string: profileImageString), completed: nil)
        commentLabel.text = comment
    }
    



}
