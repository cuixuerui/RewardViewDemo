//
//  AwardView.swift
//  RewardViewDemo
//
//  Created by cuixuerui on 2019/4/9.
//  Copyright © 2019 cuixuerui. All rights reserved.
//

import UIKit

class AwardView: UIView {
    
    private let textArcView = CXRTextArcView()
    private let imageView = UIImageView()
    private var baseAngle: CGFloat = 0
    private var radius: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupLayout()
    }
    
    private func setup() {
        addSubview(textArcView)
        addSubview(imageView)
    }
    
    private func setupLayout() {
        textArcView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
    }
    
    func set(baseAngle: CGFloat, radius: CGFloat) {
        // 设置圆弧 Label
        textArcView.textAttributes = [.foregroundColor: UIColor.white,
                                      .font: UIFont.systemFont(ofSize: 12)]
        textArcView.characterSpacing = 0.85
        textArcView.baseAngle = baseAngle
        textArcView.radius = radius
    }
    
    func set(title: String, image: String) {
        textArcView.text = title
        imageView.image = UIImage(imageLiteralResourceName: image)
    }

}
