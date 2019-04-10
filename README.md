# RewardViewDemo
抽奖大转盘
## 功能
1. 支持2个和两个以上的任意奖项
2. 支持任意角度自定义（不均等分）
3. 奖项文字弯曲环绕

## 参与开发

1. 命令行执行

   ```
   pod install
   ```
2. 打开工程 CXRRewardView.xcworkspace.

## 用法
1. 添加视图
  ```
      let rewardView = RewardView()
      view.addSubview(rewardView)
      // 设置约束
      rewardView.snp.makeConstraints { (make) in
          make.width.equalTo(300)
          make.height.equalTo(350)
          make.center.equalToSuperview()
      }
      // 设置代理
      rewardView.delegate = self
      // 填充数据
      rewardView.set(lotteries: lotteries)
  ```

2. 实现代理
  ```
  func lottery(_ completion: @escaping ((Bool, Reward.Award) -> Void)) {
      // 模拟抽奖网络请求，服务端返回 Reward.Award
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          // 假数据，应由服务端返回
          let awardId = 1
          let award = Reward.Award(id: awardId, rotationNum: 5)
          completion(true, award)
      }
  }

  func animationDidStart(_ anim: CAAnimation) {}

  func animationDidStop(_ anim: CAAnimation) {}
  ```
> 图片资源来自网络
