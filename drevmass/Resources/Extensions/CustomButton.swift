//
//  CustomButton.swift
//  drevmass
//
//  Created by Kamila Sultanova on 13.03.2024.
//

import Foundation
import SnapKit

class CustomButton: UIButton {
    
    func addTwoImagesButton(leftImage: UIImage?, rightImage: UIImage?, title: String?) {
        setTitle(title, for: .normal)
        setTitleColor(.appDark90, for: .normal)
        titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .left
        isUserInteractionEnabled = true
       

        if let leftImage = leftImage {
            let leftImageView = UIImageView(image: leftImage)
            leftImageView.contentMode = .scaleAspectFit
            addSubview(leftImageView)

            leftImageView.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
                make.size.equalTo(24)
            }
        }

        if let rightImage = rightImage {
            let rightImageView = UIImageView(image: rightImage)
            rightImageView.contentMode = .scaleAspectFit
            addSubview(rightImageView)

            rightImageView.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(16)
            }
        }
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 44)
    }
}
