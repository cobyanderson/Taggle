//
//  ViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class newGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate   {
    
    
    @IBOutlet weak var newGameTableView: UITableView!
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var friendNames: [String] = ["Eugene","Meilun","Navin","Guilherme","Tanna"]
    
    var selectedRow: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

    newGameTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.newGameTableView.dequeueReusableCellWithIdentifier("friendCell") as! UITableViewCell!
        cell.textLabel?.text = self.friendNames[indexPath.row]
        cell.textLabel?.font = UIFont(name: "STHeitiSC-Light", size: 18)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendNames.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(" the \(indexPath.row) was selected")
        
// Uncommented will allow
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        self.selectedRow = indexPath.row
//        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        toggleCell(cell!)
        
        
        

    }
    // turns checks on and off
    func toggleCell(cell: UITableViewCell) {
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.None
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
