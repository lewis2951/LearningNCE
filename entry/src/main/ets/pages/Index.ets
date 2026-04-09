@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private pages = [
    { name: '首页', icon: 'home' },
    { name: '打卡', icon: 'check-circle' },
    { name: '课程', icon: 'book' },
    { name: '统计', icon: 'pie-chart' },
    { name: '我的', icon: 'user' }
  ];

  build() {
    Column() {
      // 页面内容区域
      Stack() {
        // 首页内容
        if (this.currentIndex === 0) {
          Column() {
            Text('新概念英语学习')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 40, bottom: 30 })
            
            Text('欢迎使用新概念英语学习打卡应用！')
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .margin({ bottom: 30 })
            
            Row({
              space: 20
            }) {
              Column({
                space: 10
              }) {
                Button('开始学习')
                  .width(120)
                  .height(40)
                  .fontSize(16)
                  .backgroundColor('#007AFF')
              }
              Column({
                space: 10
              }) {
                Button('查看课程')
                  .width(120)
                  .height(40)
                  .fontSize(16)
                  .backgroundColor('#007AFF')
              }
            }
            .margin({ top: 40 })
          }
          .width('100%')
          .height('100%')
          .alignItems(HorizontalAlign.Center)
        }
        
        // 其他页面将通过路由导航实现
      }
      .width('100%')
      .flexGrow(1)

      // 底部导航栏
      Row({
        space: 0
      }) {
        ForEach(this.pages, (item, index) => {
          Column({
            space: 5
          }) {
            Text(item.icon)
              .fontSize(20)
            Text(item.name)
              .fontSize(12)
          }
          .width('20%')
          .height(60)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(this.currentIndex === index ? '#F0F0F0' : '#FFFFFF')
          .onClick(() => {
            this.currentIndex = index;
            // TODO: 实现页面切换逻辑
          })
        })
      }
      .width('100%')
      .height(60)
      .borderTop({ width: 1, color: '#E5E5E5' })
    }
    .width('100%')
    .height('100%')
  }
}