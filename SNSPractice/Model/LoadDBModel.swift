//
//  LoadDBModel.swift
//  SNSPractice
//
//  Created by あかにしらぶお on 2021/09/15.
//

import Foundation
import Firebase

protocol LoadOKDelegate {
    func loadOK(check:Int)
}


class LoadDBModel{
    
    var dataSets = [DataSet]()
    let db = Firestore.firestore()
    
    var loadOKDelegate:LoadOKDelegate?
    
    
    func loadContents(roomNumber:String){
        
        db.collection(roomNumber).order(by: "postDate").addSnapshotListener { snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let userID = data["userID"] as? String,let userName = data["userName"] as? String,let comment = data["comment"] as? String,let contentImage = data["contentImage"] as? String,let profileImage = data["userImage"] as? String,let postDate = data["postDate"] as? Double{
                        
                        let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, profileImage: profileImage, postDate: postDate, contentImage: contentImage)
                        
                        self.dataSets.append(newDataSet)
                        self.dataSets.reverse()
                        self.loadOKDelegate?.loadOK(check: 1)

                    }
                    
                }
            }
        }
    }
    
    func loadHashTag(hashTag:String){
            //addSnapShotListnerは値が更新される度に自動で呼ばれる
            db.collection("#\(hashTag)").order(by:"postDate").addSnapshotListener { (snapShot, error) in
                
                self.dataSets = []
                
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                if let snapShotDoc = snapShot?.documents{
       
                    for doc in snapShotDoc{
                        let data = doc.data()
                        if let userID = data["userID"] as? String ,let userName = data["userName"] as? String, let comment = data["comment"] as? String,let profileImage = data["userImage"] as? String,let contentImage = data["contentImage"] as? String,let postDate = data["postDate"] as? Double {
                            
                            let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, profileImage: profileImage, postDate: postDate, contentImage: contentImage)

                            self.dataSets.append(newDataSet)
                            self.dataSets.reverse()
                            self.loadOKDelegate?.loadOK(check: 1)

                        }
                        
                        
                    }
                    
                }
                
            }
            
            
        }
}
