//
//  LoginViewController.swift
//  CarJournal
//
//  Created by Cheremisin Andrey on 05.04.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let segueIdentifire = "taskSegue"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var checkPassTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        warnLabel.alpha = 0
        checkPassTextField.alpha = 0
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifire)!, sender: nil)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passTextField.text = ""
    }
    
    @objc func kbDidShow( notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    @objc func kbDidHide( notification: Notification) {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        
    }
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: {[weak self] complete in
            self?.warnLabel.alpha = 0
        }
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        checkPassTextField.alpha = 0
        guard let email = emailTextField.text, let password = passTextField.text,
              email != "", password != "" else {
            displayWarningLabel(withText: "Не корректный ввод")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Не верный логин/пароль")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: self!.segueIdentifire , sender: nil)
                return
            }
            self?.displayWarningLabel(withText: "Пользователь не найден")
        }
        
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        if checkPassTextField.alpha == 0 {
            checkPassTextField.alpha = 1
        } else {
            guard let email = emailTextField.text, let password = passTextField.text,
                  let twoPass = checkPassTextField.text,
                  email != "", password != "", password == twoPass
            else {
                displayWarningLabel(withText: "Не корректный ввод")
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
                guard user != nil else { self?.displayWarningLabel(withText: "Пользователь уже существует")
                    return
                }
            }
        }
        
    }
    
}
