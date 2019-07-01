//
//  TodoCell.swift
//  TodoListDemo
//
//  Created by Ganjiuhui on 2019/6/27.
//  Copyright © 2019 Ganjiuhui. All rights reserved.
//

import UIKit

typealias TodoCellClosure = ((_ aCell:TodoCell,_ textField:UITextField) -> Void)
typealias TodoCellActionClosure = ((_ aCell:TodoCell,_ sender:UIButton, _ isDone: Bool) -> Void)
class TodoCell: UITableViewCell {

    var isEdit:Bool = false
    var textEdit:UITextField? = nil
    var textDidChangeClosure:TodoCellClosure? = nil
    var actionBtnPressedClosure:TodoCellActionClosure? = nil
    var okButton:UIButton? = nil
    var cancelBtn: UIButton? = nil
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        okButton = UIButton.init(type: .custom)
        let OkImage = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(cellEditingDonePressed(sender:))).image
        okButton?.setImage(OkImage, for: .normal)
        okButton?.addTarget(self, action: #selector(cellEditingDonePressed(sender:)), for: .touchUpInside)
        okButton?.isHidden = true
        contentView.addSubview(okButton!)
        okButton?.backgroundColor = UIColor.red
        okButton?.setTitle("O", for: .normal)
        okButton?.setTitleColor(.white, for: .normal)
        
        cancelBtn = UIButton.init(type: .custom)
        let cancelImage = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cellEditingDonePressed(sender:))).image
        cancelBtn?.setImage(cancelImage, for: .normal)
        cancelBtn?.addTarget(self, action: #selector(cellEditingCancelPressed(sender:)), for: .touchUpInside)
        contentView.addSubview(cancelBtn!)
        cancelBtn?.isHidden = true
        cancelBtn?.backgroundColor = UIColor.red
        cancelBtn?.setTitle("X", for: .normal)
        cancelBtn?.setTitleColor(.white, for: .normal)
        
        
        let margin:CGFloat = 12.0;
        textEdit = UITextField.init(frame: CGRect.init(x: margin, y: 0, width: self.bounds.size.width - margin * 2 , height: self.bounds.size.height - margin * 2))
        textEdit?.placeholder = "请输入项目"
        textEdit?.borderStyle = .none
        textEdit?.layer.borderColor = UIColor.purple.cgColor
        textEdit?.layer.borderWidth = 0.5
        textEdit?.layer.masksToBounds = true
        textEdit?.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        contentView .addSubview(textEdit!)
        textEdit?.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       

    }
    
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textEdit?.isHidden = !self.isEdit;
        cancelBtn?.isHidden = !self.isEdit;
        okButton?.isHidden = !self.isEdit;
        
        let btnWidth:CGFloat = 44;
        let margin:CGFloat = 12;
        
        let aFrame = CGRect.init(x: self.bounds.width - margin - btnWidth, y: 0, width: btnWidth, height: btnWidth)
        cancelBtn?.frame = aFrame;
        
        let bFrame =  CGRect.init(x: aFrame.origin.x - margin - btnWidth, y: 0, width: btnWidth, height: btnWidth);
        okButton?.frame = bFrame
        
        textEdit?.frame = CGRect.init(x: margin, y: 0, width: bFrame.origin.x - margin, height: btnWidth)
    }
    
    
    //MARK: event
    @objc func textFieldDidChange(sender:UITextField) {
        guard let aClosure = self.textDidChangeClosure else {
            return
        }
        aClosure(self,sender)

    }
    
     @objc func cellEditingDonePressed(sender:UIButton){
        guard let aClosure = self.actionBtnPressedClosure else {
            return
        }
        aClosure(self,sender,true)
    }
    
     @objc func cellEditingCancelPressed(sender:UIButton){
        guard let aClosure = self.actionBtnPressedClosure else {
            return
        }
        aClosure(self,sender,false)
    }
    

}
