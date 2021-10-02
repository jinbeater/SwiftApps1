//
//  SelectRoomViewController.swift
//  SNSPractice
//
//  Created by あかにしらぶお on 2021/09/14.
//

import UIKit
import ViewAnimator

class SelectRoomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var roomArray = ["今日の1枚","爆笑報告場(草)","景色が好き！","夜景写真軍団","今日のごはん"]
    
    var imageArray = ["0","1","2","3","4"]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        tableView.isHidden = true

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isHidden = false
        //tableviewが上から順に表示されていく
        let animation = AnimationType.from(direction: .top, offset: 300)
        UIView.animate(views: tableView.visibleCells, animations: [animation],delay: 0 , duration: 1)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomArray.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        //Roomの画像を反映
        let roomImageView = cell.contentView.viewWithTag(1) as! UIImageView

        roomImageView.image = UIImage(named: imageArray[indexPath.row])

        //room名
        let roomLabel = cell.contentView.viewWithTag(2) as! UILabel
        roomLabel.text = roomArray[indexPath.row]
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 224
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //画面遷移
        let timeLineVC = self.storyboard?.instantiateViewController(identifier: "timeLineVC") as! TimeLineViewController
        timeLineVC.roomNumber = indexPath.row
        self.navigationController?.pushViewController(timeLineVC, animated: true)

        
        
    }

    



}
