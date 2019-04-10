//
//  RewardView.swift
//  RewardViewDemo
//
//  Created by cuixuerui on 2019/4/8.
//  Copyright © 2019 cuixuerui. All rights reserved.
//

import UIKit

class Reward {
    
    // 展示的奖项
    struct Lottery: Codable {
        let id: Int
        let begin: Float
        let end: Float
        let title: String
        let image: String
    }
    
    // 服务端返回抽中奖项
    struct Award {
        let id: Int
        let rotationNum: Int
    }
}

protocol RewardViewDelegate: NSObjectProtocol {
    func animationDidStart(_ anim: CAAnimation)
    func animationDidStop(_ anim: CAAnimation)
    func lottery(_ completion: @escaping ((_ result: Bool, _ award: Reward.Award) -> Void))
}

class RewardView: UIView {
    
    weak var delegate: RewardViewDelegate?
    // 开始按钮
    private let playButton = UIButton()
    // 背景转盘
    private let awardsView = UIView()
    private let rotateView = UIView()
    private let wheelImageView = UIImageView()
    // 外围的装饰图层
    private let backImageView = UIImageView()
    // 上次转动角度
    private var rotationAngle: CGFloat = 0
    // 动画是否正在执行
    private var isAnimating: Bool = false
    
    private var lotteries: [Reward.Lottery] = []
    
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
        addSubview(rotateView)
        addSubview(playButton)
        addSubview(backImageView)
        rotateView.addSubview(wheelImageView)
        rotateView.addSubview(awardsView)
        backImageView.contentMode = .scaleToFill
        wheelImageView.image = #imageLiteral(resourceName: "qiandao_0008_yy")
        backImageView.image = #imageLiteral(resourceName: "2_0000_up")
        playButton.addTarget(self, action: #selector(lottery), for: .touchUpInside)
    }
    
    private func setupLayout() {
        rotateView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(rotateView.snp.width)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.center.equalTo(rotateView.snp.center)
        }
        
        wheelImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        awardsView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backImageView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(rotateView.snp.height).offset(30)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    deinit {
        rotateView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    @objc private func lottery() {
        guard !isAnimating else { return }
        delegate?.lottery({ [weak self] (result, award)  in
            guard let self = self, result else { return }
            self.startAnimation(num: award.rotationNum, awardId: award.id)
        })
    }
    
    /// 开始旋转动画
    ///
    /// - Parameters:
    ///   - num: 转动圈数
    ///   - awardId: 所中奖品Id
    private func startAnimation(num: Int, awardId: Int) {
        guard
            !isAnimating,
            let lottery = lotteries.first(where: { $0.id == awardId }) else {
                return
        }
        
        let rotationAngle = -CGFloat((lottery.begin + lottery.end) / 360.0 * .pi )
        self.rotationAngle = rotationAngle
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = rotationAngle + 360 * .pi / 180.0 * CGFloat(num)
        animation.duration = CFTimeInterval(num) + 0.5
        animation.isCumulative = false
        animation.delegate = self
        
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        rotateView.layer.add(animation, forKey: "rotationAnimation")
    }

}

extension RewardView {
    
    func set(lotteries: [Reward.Lottery]) {
        self.lotteries = lotteries
        reloadData()
    }
    
    private func reloadData() {
        layoutIfNeeded()
        // 移除子视图
        for view in awardsView.subviews {
            view.removeFromSuperview()
        }
        // 添加 awardView 视图
        for lottery in lotteries {
            
            let ratio = CGFloat(lottery.end - lottery.begin)/360.0
            let angle = (ratio > 0.5 ? 0.5 : ratio) * .pi
            let frame = CGRect(x: 0,
                               y: 0,
                               width: rotateView.bounds.width / 2 * sin(angle),
                               height: rotateView.bounds.height / 2)
            
            let awardView = AwardView(frame: frame)
            awardView.layer.anchorPoint = CGPoint(x: 0.5, y: 1);
            awardView.center = CGPoint(x: rotateView.bounds.width / 2,
                                       y: rotateView.bounds.width / 2)
            awardView.set(baseAngle: 270 * .pi / 180, radius: 75)
            awardView.set(title: lottery.title, image: lottery.image)
            
            let rotationAngle = CGFloat((lottery.begin + lottery.end) / 360.0 * .pi )
            awardView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            awardsView.addSubview(awardView)
        }
    }
}

extension RewardView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        isAnimating = true
        delegate?.animationDidStart(anim)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isAnimating = false
        // rotateView 旋转到当前位置
        rotateView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        rotateView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        delegate?.animationDidStop(anim)
    }
}
