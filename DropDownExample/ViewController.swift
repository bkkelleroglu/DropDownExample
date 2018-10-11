//
//  ViewController.swift
//  DropDownExample
//
//  Created by Burak Kelleroğlu on 10.10.2018.
//  Copyright © 2018 Burak Kelleroğlu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var button = dropDownButton()
    let dropDownImage = #imageLiteral(resourceName: "arrow_down")
    let padding : CGFloat = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button = dropDownButton.init(frame: CGRect.zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        
        
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 43).isActive = true
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        let arrayOfCellData = [cellData(bankImage: #imageLiteral(resourceName: "isbanklogo"), bankName: "İş Bankası TRY Bakiyeleri"),
                               cellData(bankImage: #imageLiteral(resourceName: "denizbanklogo"), bankName: "Denizbank TRY Bakiyeleri"),
                               cellData(bankImage: #imageLiteral(resourceName: "teblogo"), bankName: "TEB TRY Bakiyeleri")]
        
        
        
        button.setTitle("TRY Banka Bakiyeleri", for: .normal)
        button.setTitleColor(UIColor(red: 33 / 255, green: 42 / 255, blue: 64 / 255, alpha: 1.0), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setImage(dropDownImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, button.frame.size.width, 0, button.frame.size.width - 15)
        button.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        //        button.dropView.dropDownOptions = ["İş Bankası TRY Bakiyeleri","Akbank TRY Bakiyeleri","Garanti Bankası TRY Bakiyeleri"]
        button.dropView.dropDownOptions = arrayOfCellData
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Accounts VC will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Accounts VC will disappear")
    }
    
    
}
struct cellData {
    let bankImage : UIImage!
    let bankName : String!
}

protocol dropDownProtocol {
    func dropDownPressed(string : String)
}
class dropDownButton: UIButton ,dropDownProtocol{
    func dropDownPressed(string : String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    
    var dropView = dropDownView()
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        dropView.tintColor = UIColor(red: 33 / 255, green: 42 / 255, blue: 64 / 255, alpha: 1.0)
        dropView = dropDownView.init(frame: CGRect.zero)
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        
        // constraints
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false{
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            if  self.dropView.tableView.contentSize.height > 150{
                self.height.constant = 150
            }else{
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        }else{
            isOpen = false
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    func dismissDropDown(){
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class dropDownView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    var dropDownOptions = [cellData]()
    var tableView = UITableView()
    var delegate : dropDownProtocol!
    var customImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.backgroundColor = UIColor.white
        cell.imageView?.image = dropDownOptions[indexPath.row].bankImage

       cell.imageView?.addConstraint(NSLayoutConstraint(item: cell.contentView, attribute: .centerX, relatedBy: .equal, toItem: customImageView, attribute: .centerX, multiplier: 1.0, constant: 0))
        cell.imageView?.addConstraint(NSLayoutConstraint(item: cell.contentView, attribute: .centerY, relatedBy: .equal, toItem: customImageView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        
        
        return cell
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row].bankName)
        print(dropDownOptions[indexPath.row])
    }
}













