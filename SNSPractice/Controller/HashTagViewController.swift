//
//  HashTagViewController.swift
//  SNSPractice
//
//  Created by あかにしらぶお on 2021/09/16.
//

import UIKit
import SDWebImage

class HashTagViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LoadOKDelegate {
    
    var hashTag = String()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    var loadDBModel = LoadDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        loadDBModel.loadOKDelegate = self
        self.navigationItem.title = "#\(hashTag)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topImageView.layer.cornerRadius = 50
        
        //ロード
        loadDBModel.loadHashTag(hashTag: hashTag)
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        countLabel.text = String(loadDBModel.dataSets.count)
        
        return loadDBModel.dataSets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let contentImageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        contentImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].contentImage
        ), completed: nil)
        
        topImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[0].contentImage), completed: nil)
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //値を渡しながら画面遷移
        let detailVC = self.storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        
        detailVC.userName = loadDBModel.dataSets[indexPath.row].userName
        detailVC.comment = loadDBModel.dataSets[indexPath.row].comment
        detailVC.contentImageString = loadDBModel.dataSets[indexPath.row].contentImage
        detailVC.profileImageString = loadDBModel.dataSets[indexPath.row].profileImage

        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    //loadDBModelで作成したプロトコルで、配列の値が最新であればリロードされる
    func loadOK(check: Int) {
        if check == 1{
            collectionView.reloadData()
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //幅と高さをコレクションビューの1/3にしている。正方形
        
           let width = collectionView.bounds.width/3.0
           let height = width

           return CGSize(width: width, height: height)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets.zero
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }

}
