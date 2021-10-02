//
//  SendDBModel.swift
//  SNSPractice
//
//  Created by あかにしらぶお on 2021/09/14.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class SendDBModel{
    
    var userID = String()
    var userName = String()
    var comment = String()
    var userImageString = String()
    var contentImageData = Data()
    var db = Firestore.firestore()
    //DBへのデータ送信機能を集約する
    init(){
        
    }
    
    init(userID:String,userName:String,comment:String,userImageString:String,contentImageData:Data) {
        
        //受け取ったデータをクラス内の他のメソッドで使用するためにフィールドに代入している
        self.userID = userID
        self.userName = userName
        self.comment = comment
        self.userImageString = userImageString
        self.contentImageData = contentImageData
        
    }
    
    
    //投稿された画像をストレージに保存し、返ってきたURLを使ってfirestoreに文字列として保存
    func sendData(roomNumber:String){
        
        //送信処理
        let imageRef = Storage.storage().reference().child("Images").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        //ストレージに画像を保存した際のリアクションを受け取っている
        imageRef.putData(contentImageData, metadata: nil) { metadata, error in
            
            if error != nil{
                return
            }
            //画像の保存先のURLが返ってきているので受け取っている
            imageRef.downloadURL { url, error in
                
                if error != nil{
                    return
                }
                
                self.db.collection(roomNumber).document().setData(["userID" : self.userID,"userName":self.userName,"comment":self.comment,"userImage":self.userImageString,"contentImage":url?.absoluteString as Any,"postDate":Date().timeIntervalSince1970])
                
            }
        }
    }
    
    //プロフィール画像をDBに保存するメソッド
    func sendProfileImageData(data:Data){
        //画像データをData型で受け取る
        let image = UIImage(data: data)
        //画像データを10分の1のサイズに圧縮する
        let profileImage = image!.jpegData(compressionQuality: 0.1)
        
        
        //FIrestoreのストレージにprofileImageというフォルダを作成して
        //その中にUUID.現在時刻の名前をつけて画像ファイルを保存している
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        //ストレージに画像を保存した際のリアクションを受け取っている
        imageRef.putData(profileImage!, metadata: nil) { metadata, error in
            
            if error != nil{
                return
            }
            //画像の保存先のURLが返ってきているので受け取っている
            imageRef.downloadURL { url, error in
                
                if error != nil{
                    return
                }
                //受け取ったURLを文字列としてアプリ内に保存している
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
                
            }
        }
    }
    
    //ハッシュタグをコレクション名にしたデータをDBに入れている
    func sendHashTag(hashTag:String){
        
        let imageRef = Storage.storage().reference().child(hashTag).child("\(UUID().uuidString +  String(Date().timeIntervalSince1970)).jpg")
        
        
        imageRef.putData(contentImageData, metadata: nil, completion: { (metadata, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                self.db.collection(hashTag).document().setData(["userID":self.userID as Any,"userName":self.userName as Any,"comment":self.comment as Any,"userImage":self.userImageString as Any,"contentImage":url?.absoluteString as Any,"postDate":Date().timeIntervalSince1970])
                
                
            })
        })
        
        
    }
    
}
