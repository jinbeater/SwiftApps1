//
//  CheckModel.swift
//  SNSPractice
//
//  Created by あかにしらぶお on 2021/09/14.
//

import Foundation
import Photos


class CheckModel{
    
    func showCheckPermission(){
           PHPhotoLibrary.requestAuthorization { (status) in
               
               switch(status){
                   
               case .authorized:
                   print("許可されてますよ")

               case .denied:
                       print("拒否")

               case .notDetermined:
                           print("notDetermined")
                   
               case .restricted:
                           print("restricted")
                   
               case .limited:
                   print("limited")
               @unknown default: break
                   
               }
               
           }
       }
}
