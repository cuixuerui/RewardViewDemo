//
//  ViewController.swift
//  RewardViewDemo
//
//  Created by Lucas on 2019/4/10.
//  Copyright © 2019 cuixuerui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var id: Int = 8
    override func viewDidLoad() {
        super.viewDidLoad()
        let lotteries = [Reward.Lottery(id: 1, begin: -22.5, end: 22.5, title: "1234567", image: "qiandao_0000_000"),
                         Reward.Lottery(id: 2, begin: 22.5, end: 67.5, title: "2345", image: "qiandao_0001_001"),
                         Reward.Lottery(id: 3, begin: 67.5, end: 112.5, title: "3456", image: "qiandao_0000_000"),
                         Reward.Lottery(id: 4, begin: 112.5, end: 157.5, title: "4", image: "qiandao_0004_02"),
                         Reward.Lottery(id: 5, begin: 157.5, end: 201.5, title: "567", image: "qiandao_0000_000"),
                         Reward.Lottery(id: 6, begin: 201.5, end: 247.5, title: "678", image: "qiandao_0003_01"),
                         Reward.Lottery(id: 7, begin: 247.5, end: 292.5, title: "789", image: "qiandao_0002_003"),
                         Reward.Lottery(id: 8, begin: 292.5, end: 337.5, title: "8", image: "qiandao_0000_000")]
        
        let rewardView = RewardView()
        view.addSubview(rewardView)
        rewardView.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(350)
            make.center.equalToSuperview()
        }
        rewardView.delegate = self
        rewardView.set(lotteries: lotteries)
    }
    
}

extension ViewController: RewardViewDelegate {
    func lottery(_ completion: @escaping ((Bool, Reward.Award) -> Void)) {
        // 模拟网路请求，服务端返回 Reward.Award
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let award = Reward.Award(id: self.id, rotationNum: 5)
            completion(true, award)
            self.id -= 1
            self.id = self.id <= 0 ? 8 : self.id
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {}
    
    func animationDidStop(_ anim: CAAnimation) {}
    
}


