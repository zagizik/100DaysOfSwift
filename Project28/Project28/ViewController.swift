//
//  ViewController.swift
//  Project28
//
//  Created by Александр Банников on 23.08.2020.
//  Copyright © 2020 BananaWorks. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var secret: UITextView!
    let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
    let leftBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(passwordUsgate))
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(passwordUsgate))
        title = "Nothing to see here"
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        ac.addAction(UIAlertAction(title: "Use password", style: .default, handler: self?.passwordUsgate))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        navigationItem.setLeftBarButton(nil, animated: true)
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        navigationItem.setRightBarButton(nil, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(passwordUsgate))
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
    @objc func passwordUsgate(action: UIAlertAction){
        print("tapped")
        if KeychainWrapper.standard.string(forKey: "pswrd") == nil {
            let ac = UIAlertController(title: "Set new password", message: "There was no password added, you need to set new", preferredStyle: .alert)
            ac.addTextField()
            let setPassword = UIAlertAction(title: "Set", style: .default) { [weak ac] action in
                guard let answer = ac?.textFields?[0].text else { return }
                if answer == "" { return } else {
                    print(answer)
                    KeychainWrapper.standard.set(answer, forKey: "pswrd")
                }
            }
            ac.addAction(setPassword)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Type passord", message: nil, preferredStyle: .alert)
            ac.addTextField()
            let checkPassword = UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] action in
                guard let answer = ac?.textFields?[0].text else { return }
                print(answer)
                if answer == "" { return } else {
                    if KeychainWrapper.standard.string(forKey: "pswrd") == answer {
                        self?.unlockSecretMessage()
                    }
                }
            }
            ac.addAction(checkPassword)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
    }
    
}

