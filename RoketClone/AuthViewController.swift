//
//  ViewController.swift
//  RoketClone
//
//  Created by Othman Mashaab on 17/03/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AuthViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    
    @IBOutlet weak var reserEmaiTF: UITextField!
    @IBOutlet weak var forgotpassBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var gotoLoginBtn: UIButton!
    @IBOutlet weak var loginPasswordTF: UITextField!
    @IBOutlet weak var loginEmailTF: UITextField!
    
    @IBOutlet weak var singupNowBtn: UIButton!
    @IBOutlet weak var signupUsernameTF: UITextField!
    @IBOutlet weak var signupEmailTF: UITextField!
    @IBOutlet weak var signupPasswordTF: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var ref: FIRDatabaseReference!
    
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        picker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRecoverEmailTapped(_ sender: Any) {
        if self.reserEmaiTF.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.reserEmaiTF.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.reserEmaiTF.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    
    }
    @IBAction func loginBtnTapped(_ sender: Any) {
        
        if self.loginEmailTF.text == "" || self.loginPasswordTF.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.loginEmailTF.text!, password: self.loginPasswordTF.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let mainstoryboard:UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "TabBarSB")
                    self.present(newViewcontroller, animated: true, completion: nil)
                    
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func addPictureTapped(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "set an image as a profile picture", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let photoLibraryOption = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) -> Void in
            print("from library")
            //shows the photo library
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
        })
        
        let cancelOption = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
            self.dismiss(animated: true, completion: nil)
        })
        
        optionMenu.addAction(photoLibraryOption)
        optionMenu.addAction(cancelOption)
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    

    @IBAction func signupBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "signupSegue", sender: signUpBtn)
    }
    @IBAction func gotologinBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: gotoLoginBtn)
    }
    @IBAction func forgotpassTapped(_ sender: Any) {
        performSegue(withIdentifier: "forgotpasswordSegue", sender: forgotpassBtn)
    }
    
    @IBAction func signUpNowTapped(_ sender: Any) {
        if signupEmailTF.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: signupEmailTF.text!, password: signupPasswordTF.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let alertController = UIAlertController(title: "Sign up Successfull", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    }
                
                guard let uid = user?.uid else {
                    return
                }
//                else {
//                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                    
//                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//                    
//                    self.present(alertController, animated: true, completion: nil)
//                }
                let email = self.signupEmailTF.text
                let password = self.signupPasswordTF.text
                let name = self.signupUsernameTF.text
                let imageName = UUID().uuidString
                let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
                
                if let profileImage = self.profilePicture.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                            
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                            
                            self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                        }
                    })
                }
            }
                
            
        }
    } //Main
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            
            
            let user = User()
            user.setValuesForKeys(values)
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("finished picking image")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //handle media here i.e. do stuff with photo
        
        print("imagePickerController called")
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePicture.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //what happens when you cancel
        //which, in our case, is just to get rid of the photo picker which pops up
        dismiss(animated: true, completion: nil)
    }
   
    

}

