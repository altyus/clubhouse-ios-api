//
//  StoriesTableViewController.swift
//  clubhouse-ios-api
//
//  Created by AL TYUS on 4/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import clubhouse_ios_api

class StoriesTableViewController: UITableViewController {
    var epic: Epic? = nil
    private var stories: [Story]? = []
    private let reuseIdentifier = "StoryCell"
    
    override func viewDidLoad() {
        guard let epic = epic else {
            return
        }
        self.navigationItem.title = epic.name
        
        ClubhouseAPI.sharedInstance.searchStories([StoryParam.EpicId(epic.id)], success: { stories in
            self.stories = stories.sort { $0.name?.lowercaseString < $1.name?.lowercaseString }
            self.tableView.reloadData()
            }, failure: { error in
                print(error)
        })
    }
}

extension StoriesTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let stories = stories else {
            return 0
        }
        
        return stories.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) else {
            return UITableViewCell(style: .Default, reuseIdentifier: reuseIdentifier)
        }
        let story = storyAt(indexPath: indexPath)
        
        cell.textLabel?.text = story?.name
        
        return cell
    }
    
    private func storyAt(indexPath indexPath: NSIndexPath) -> Story? {
        guard let stories = stories else {
            return nil
        }
        return stories[indexPath.row]
    }
}

extension StoriesTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
