//
//  ProfileViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/3/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var imageView: MKImageView!
    @IBOutlet weak var userInfolabel: UILabel!
    let imagePicker = UIImagePickerController()

   let currentUser = PFUser.currentUser()
    var currentUserr = PFUser()
    
    var passedInObjectSession = PFObject?()
    
    @IBOutlet weak var radiusSlider: UISlider!
    
    let step: Float = 1
    
    let sharedPref = NSUserDefaults.standardUserDefaults()
    var newSession = PFObject?()

    
    
    @IBAction func radiusSelector(sender: UISlider) {
       
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        let sharedPref = NSUserDefaults.standardUserDefaults()
        
         sharedPref.setValue(radiusSlider.value, forKey: "radiusToSearchWithin")
        
       
    }
    
    @IBAction func logOut(sender: AnyObject) {
        
      
        
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        PFUser.logOut()
        
        
       
        print("You have successfully logged out")
        
    }
    
    @IBAction func profilePictureChooser(sender: AnyObject) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var backToGameButton: UIButton!
    
    @IBAction func goBackToGame(sender: AnyObject) {
        
        print("???")
        
        
        let hostedSession = sharedPref.stringForKey("currentSessionHost")

        
         let sendthis = passedInObjectSession
        
        sendthis?.fetchIfNeededInBackgroundWithBlock({ (object:PFObject?, error:NSError?) in
            print(sendthis?.objectId)
        })
        
        performSegueWithIdentifier("backToSessionHost", sender: self)
       // print(sendthis!.objectId)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "backToSessionHost")
        {
            var vc = segue.destinationViewController as! HostSessionPageViewController
            vc.hostedSessionObject = passedInObjectSession
        }
    }
    
  
    
    func findSessionAgain(objectOfGame:String)-> PFObject
    {
       
        
        var query = PFQuery(className: "GameOnSession")
        query.whereKey("objectId", equalTo: objectOfGame)
        query.findObjectsInBackgroundWithBlock { (object:[PFObject]?, error:NSError?) in
            if (error == nil)
            {
                self.newSession = object?[0]
                //print(self.newSession)
                
            } else {
                print("error")
            }
        }
        
       return newSession!
        
    }
    func queryProfilePicture()
    {
       if currentUser != nil
       {
        var userQuery = PFUser.query()
        userQuery!.whereKey("objectId", equalTo: currentUser!.objectId!)
        userQuery!.findObjectsInBackgroundWithBlock {
            (object:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                
                print((self.currentUser?.objectId)!)
                
                if let imagedisplay = object?[0]["profilePicture"] as? PFFile
                {
                    imagedisplay.getDataInBackgroundWithBlock { (result, error) in
                        if (error == nil)
                        {self.imageView.contentMode = .ScaleAspectFit
                            self.imageView.image = UIImage(data: result!)
                            
                            
                        }else {
                            print("shit")
                        }
                    }
                }
                
               
                
            }
            else {
                print("Error")
            }
            
        }
        
       } else {
        print("current user is nil...")
        }
        
       
    
    
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
       
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        
        imagePicker.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let radiusSearch = defaults.floatForKey("radiusToSearchWithin")
        
        radiusSlider.setValue(radiusSearch, animated: true)
        
        let theones = sharedPref.stringForKey("currentSessionHost")
        if (theones == "")
        {
            backToGameButton.hidden = true
        }
        
       
               
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            
            let profileImageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
            
            if (profileImageData != nil)
            {
                let profileImageFile = PFFile(data: profileImageData!)
                currentUser?.setObject(profileImageFile!, forKey: "profilePicture")
                currentUser?.saveInBackground()
                print("SUCCESSFUL IMAGE UPLOAD")
            }
            else {
                print("ERROR SAVING IMAGE TO PARSE")
            }
           
            
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        var currentUser = PFUser.currentUser()
       
       

        if currentUser != nil{
            let firstname = currentUser!["firstName"] as! String
            let lastname = currentUser!["lastName"] as! String
            userInfolabel.text = "Welcome \(firstname) \(lastname)!"
            
        }else {
            userInfolabel.text = "User is here"
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil
        {
            queryProfilePicture()
        }
     
        if (sharedPref.stringForKey("currentSessionHost") != nil)
        {
            backToGameButton.hidden = false
        }
        
    }
    
   

}
