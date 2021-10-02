//
//  LoginViewController.swift
//  SNSPractice
//
//  Created by あかにしらぶお on 2021/09/14.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var urlString = String()
    
    let sendDBModel = SendDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //許可画面
        let checkModel = CheckModel()
        checkModel.showCheckPermission()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        //匿名ログイン
        Auth.auth().signInAnonymously { result, error in
            
            if error != nil{
                return
            }
            
            let user = result?.user
            //次の画面へ遷移
            let selectVC = self.storyboard?.instantiateViewController(identifier: "selectVC") as! SelectRoomViewController
            
            UserDefaults.standard.setValue(self.textField.text, forKey: "userName")
            
            //画像をクラウドサーバへ送信
            //まずは画像の圧縮を行う
            let data = self.profileImageView.image?.jpegData(compressionQuality: 0.01)
            
            //dataをストレージへ保存
            //クラス名.setImageData(data:data)
            self.sendDBModel.sendProfileImageData(data: data!)
            
            self.navigationController?.pushViewController(selectVC, animated: true)
            
        }
        
        
    }
    
    func doCamera(){
            
            let sourceType:UIImagePickerController.SourceType = .camera
            
            //カメラ利用可能かチェック
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                let cameraPicker = UIImagePickerController()
                cameraPicker.allowsEditing = true
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                
                
            }
            
        }
        
        
        func doAlbum(){
            
            let sourceType:UIImagePickerController.SourceType = .photoLibrary
            
            //カメラ利用可能かチェック
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let cameraPicker = UIImagePickerController()
                cameraPicker.allowsEditing = true
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                
                
            }
            
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            if info[.originalImage] as? UIImage != nil{
                
                let selectedImage = info[.originalImage] as! UIImage
                profileImageView.image = selectedImage
                picker.dismiss(animated: true, completion: nil)
                
            }
            
        }
    
    
       
    //UIImageをタップされたとき
    @IBAction func tapImageView(_ sender: Any) {
        
        //写真が震える挙動を表している
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        showAlert()
    }
    

    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         
         picker.dismiss(animated: true, completion: nil)
         
     }
     
     
     //アラート
     func showAlert(){
         
         let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
         
         let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
             
             self.doCamera()
             
         }
         let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
             
             self.doAlbum()
             
         }

         let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
         
         
         alertController.addAction(action1)
         alertController.addAction(action2)
         alertController.addAction(action3)
         self.present(alertController, animated: true, completion: nil)
         
     }
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         
         textField.resignFirstResponder()
         
     }


}
