//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Thomas Muehlegger on 15.02.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload to show memes after adding a meme
        tableView.reloadData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Directly open the meme editor view when no meme stored
        if appDelegate.memes.count == 0 {
            showEditorView()
        }
    }
    
    // Action to open the editor view
    @IBAction func openEditorView(_ sender: Any) {
        showEditorView()
    }
    
    // Show the editor view
    func showEditorView() {
        let editorViewController = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(editorViewController, animated: true, completion: nil)
    }
    
    // Return the number of stored memes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count
    }
    
    // Set the image, top label and bottom label of the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell") as! SentMemesTableViewCell
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        cell.topLabel?.text = meme.topText
        cell.bottomLabel?.text = meme.bottomText
        
        return cell
    }
    
    // Open MemeDetailViewController when clicking on a table item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memeDetailViewController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}
