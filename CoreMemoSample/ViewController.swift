//
//  ViewController.swift
//  CoreMemoSample
//
//  Created by Hayashidesu. on 2015/11/09.
//  Copyright © 2015年 Hayashidesu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let ENTITY_NAME = "Memo"
    let ITEM_NAME = "text"
    
    @IBOutlet weak var txtCoredata: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtCoredata.text = readData()
    }
    
    
   
    @IBAction func pressSaveButton(sender: UIButton) {
        writeData(txtCoredata.text!)
    }
    
    @IBAction func pressDeleteButton(sender: UIButton) {
        txtCoredata.text = nil
        deleteData()
    }
    
    // データ登録/更新
    func writeData(txtMemo: String) -> Bool{
        var ret = false
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                // 検索して見つかったらアップデートする
                let obj = results[0] as! NSManagedObject
                let txt = obj.valueForKey(ITEM_NAME) as! String
                obj.setValue(txtMemo, forKey: ITEM_NAME)
                print("UPDATE \(txt) TO \(txtMemo)")
                appDelegate.saveContext()
                ret = true
                
            }else{
                // 見つからなかったら新規登録
                let entity: NSEntityDescription! = NSEntityDescription.entityForName(ENTITY_NAME, inManagedObjectContext: context)
                let obj = Memo(entity: entity, insertIntoManagedObjectContext: context)
                obj.setValue(txtMemo, forKey: ITEM_NAME)
                print("INSERT \(txtMemo)")
                do {
                    try context.save()
                } catch let error as NSError {
                    // エラー処理
                    print("INSERT ERROR:\(error.localizedDescription)")
                }
                ret = true
            }
        } catch let error as NSError {
            // エラー処理
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        return ret
    }
    
    // データ読み込み
    func readData() -> String{
        var ret = ""
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            let results : Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                // 見つかったら削除
                let obj = results[0] as! NSManagedObject
                let txt = obj.valueForKey(ITEM_NAME) as! String
                print("READ:\(txt)")
                ret = txt
            }
        } catch let error as NSError {
            // エラー処理
            print("READ ERROR:\(error.localizedDescription)")
        }
        return ret
    }
    
    // データ削除
    func deleteData() -> Bool {
        var ret = false
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            let results : Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                // 見つかったら削除
                let obj = results[0] as! NSManagedObject
                let txt = obj.valueForKey(ITEM_NAME) as! String
                print("DELETE \(txt)")
                context.deleteObject(obj)
                appDelegate.saveContext()
            }
            ret = true
        } catch let error as NSError {
            // エラー処理
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        return ret
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

