//
//  EditViewController.swift
//  SNSPractice
//
//  Created by あかにしらぶお on 2021/09/15.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class EditViewController: UIViewController {
    
    var roomNumber = Int()
    var passImage = UIImage()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    var userName = String()
    
    var userImageString =  String()
    
    let screenSize = UIScreen.main.bounds.size
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageString = UserDefaults.standard.object(forKey: "userImage") as! String
        }
        
        userNameLabel.text = userName
        profileImageView.sd_setImage(with: URL(string: userImageString), completed: nil)
        contentImageView.image = passImage
        profileImageView.layer.cornerRadius = 50
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    @objc func keyboardWillShow(_ notification:NSNotification){
        
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        
        textField.frame.origin.y = screenSize.height - keyboardHeight - textField.frame.height
        sendButton.frame.origin.y = screenSize.height - keyboardHeight - sendButton.frame.height
        
        
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification){
        textField.frame.origin.y = screenSize.height - textField.frame.height
        sendButton.frame.origin.y = screenSize.height - sendButton.frame.height
        //空判定を
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
        
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    

    //テキストを入力した際にハッシュタグだけを切り取ってsendDBModelに送り、DBに保存している
    func searchHashTag(){

     let hashTagText = textField.text as NSString?
            do{
                let regex = try NSRegularExpression(pattern: "#\\S+", options: [])
                for match in regex.matches(in: hashTagText! as String, options: [], range: NSRange(location: 0, length: hashTagText!.length)) {

                    let passedData = self.passImage.jpegData(compressionQuality: 0.01)
                    let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: self.userName, comment: self.textField.text!, userImageString:self.userImageString,contentImageData:passedData!)
                    //含まれているハッシュタグをすべて格納している
                    sendDBModel.sendHashTag(hashTag: hashTagText!.substring(with: match.range))
                }
            }catch{
                
            }
    }
    
    
    
    @IBAction func send(_ sender: Any) {
        
        if textField.text?.isEmpty == true{
            return
        }
        
        searchHashTag()
        
        let passData = passImage.jpegData(compressionQuality: 0.01)
        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, comment: textField.text!, userImageString: userImageString, contentImageData: passData!
        )
        sendDBModel.sendData(roomNumber: String(roomNumber
        ))
        //一つ前の画面に戻る
        self.navigationController?.popViewController(animated: true
        )
    }
    
}
