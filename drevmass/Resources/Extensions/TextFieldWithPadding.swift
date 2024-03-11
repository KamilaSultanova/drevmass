//
//  TextFieldWithPadding.swift
//  Ozinshe
//
//  Created by Kamila Sultanova on 22.11.2023.
//

import Foundation
import UIKit

class TextFieldWithPadding: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 36);
    var bottomBorderColor: UIColor = UIColor.appGray50 {
        didSet {
            updateBottomBorder()
        }
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            
            self.tintColor = .appDark90
            self.borderStyle = .none
            updateBottomBorder()
        }

    func addBottomBorder(withColor color: UIColor, andHeight height: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
        layer.addSublayer(border)
    }
    
    private func updateBottomBorder() {
           // Remove existing bottom border layers
           layer.sublayers?.filter { $0.frame.height == 1 }.forEach { $0.removeFromSuperlayer() }
           
           // Add a new bottom border with the updated color
           addBottomBorder(withColor: bottomBorderColor, andHeight: 1)
       }
    
    init() {
        super.init(frame: .zero)
        self.font = UIFont.appFont(ofSize: 17, weight: .semiBold)
       }

       required init?(coder: NSCoder) {
           super.init(coder: coder)
       }
}
