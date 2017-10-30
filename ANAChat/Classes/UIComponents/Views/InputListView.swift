//
//  InputListView.swift
//

import UIKit

class InputListView: UIView {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var delegate: InputCellProtocolDelegate?
    var messageObject : InputTypeOptions!
    var options: [Any]?
    var selectedItemsArray =  NSMutableArray()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    func configureUI(){
        self.cellContentView.layer.cornerRadius = 2.0
        self.cellContentView.layer.masksToBounds = true
        self.submitButton.layer.cornerRadius = 2.0
        self.submitButton.layer.masksToBounds = true
        self.submitButton.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
        tableView.register(UINib.init(nibName: "ChatListTableViewCell", bundle: CommonUtility.getFrameworkBundle()), forCellReuseIdentifier: "ChatListTableViewCell")
    }
    
    public func configure(messageObject : InputTypeOptions){
        self.messageObject = messageObject
        let sortDescriptor = NSSortDescriptor(key: Constants.kIndexKey, ascending: true)
        self.options = self.messageObject.options?.sortedArray(using: [sortDescriptor])
        self.tableView.reloadData()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if self.selectedItemsArray.count > 0{
            var inputValue =  String()
            var inputTitle =  String()
            for index in 0 ..< self.selectedItemsArray.count{
                if let optionsObject = self.selectedItemsArray[index] as? Options{
                    if let value = optionsObject.value{
                        inputValue.append(value)
                        if index < self.selectedItemsArray.count - 1{
                            inputValue.append(",")
                        }
                    }
                    if let title = optionsObject.title{
                        inputTitle.append(title)
                        if index < self.selectedItemsArray.count - 1{
                            inputTitle.append(",")
                        }
                    }
                }
            }
            self.removeFromSuperview()
            
            let inputDict = [Constants.kInputKey: [Constants.kValKey: inputValue,Constants.kTextKey : inputTitle]]
            delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)

        }else{
            self.delegate?.showAlert?("Please select atleast one option")
        }
    }
}

extension InputListView : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "ChatListTableViewCell"
        let cell: ChatListTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath ) as? ChatListTableViewCell
        if let optionsObject = self.options?[indexPath.row] as? Options{
            cell?.configureView(self.options?[indexPath.row] as! Options)
            if self.selectedItemsArray.contains(optionsObject){
                cell?.selectionImageView.image = UIImage(named: "selectedImage")
            }else{
                cell?.selectionImageView.image = UIImage(named: "unselectedImage")
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (self.options?.count)! > 0{
            return (self.options?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let optionsObject = self.options?[indexPath.row] as? Options{
            if self.messageObject.multiple == 1{
                if self.selectedItemsArray.contains(optionsObject){
                    self.selectedItemsArray.remove(optionsObject)
                }else{
                    self.selectedItemsArray.add(optionsObject)
                }
            }else{
                self.selectedItemsArray = NSMutableArray()
                self.selectedItemsArray.add(optionsObject)
            }
          
            self.tableView.reloadData()
        }
    }
}
