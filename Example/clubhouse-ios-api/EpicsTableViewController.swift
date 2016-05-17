//
//  EpicsTableViewController.swift
//  clubhouse-ios-api
//
//  Created by AL TYUS on 4/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import clubhouse_ios_api

class EpicsTableViewController: UITableViewController {
    private var epics: [Epic] = []
    private let reuseIdentifier = "EpicCell"
    
    override func viewDidLoad() {
        ClubhouseAPI.sharedInstance.listEpics({ epics in
            self.epics = epics.sort {
                $0.name.lowercaseString < $1.name.lowercaseString
            }
            self.tableView.reloadData()
            }, failure: { error in
                print(error)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let
            storiesVc = segue.destinationViewController as? StoriesTableViewController,
            indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        storiesVc.epic = epicAt(indexPath: indexPath)
    }
}

//MARK: - UITableViewDataSource
extension EpicsTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return epics.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) else {
            return UITableViewCell(style: .Default, reuseIdentifier: reuseIdentifier)
        }
        let epic = epicAt(indexPath: indexPath)
        
        cell.textLabel?.text = epic.name
        
        return cell
    }
    
    private func epicAt(indexPath indexPath: NSIndexPath) -> Epic {
        return self.epics[indexPath.row]
    }
}

//MARK: - UITableViewDelegate
extension EpicsTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("StoriesSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}