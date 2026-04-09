import { CheckinModel } from '../model/CheckinModel';
import { CourseModel } from '../model/CourseModel';

@Entry
@Component
struct StatisticPage {
  @State totalDays: number = 0;
  @State consecutiveDays: number = 0;
  @State totalStudyTime: number = 0; // 分钟
  @State completedLessons: number = 0;
  @State isLoading: boolean = true;
  @State weeklyData: Array<{ day: string; count: number }> = [];

  aboutToAppear() {
    this.loadStatistics();
    this.loadWeeklyData();
  }

  async loadStatistics() {
    this.isLoading = true;
    try {
      // 加载打卡统计
      this.totalDays = await CheckinModel.getTotalCheckinDays();
      this.consecutiveDays = await CheckinModel.getConsecutiveDays();
      
      // 计算总学习时长
      const records = await CheckinModel.getCheckins();
      this.totalStudyTime = records.reduce((total, record) => total + (record.studyTime || 0), 0);
      
      // 加载课程完成情况
      this.completedLessons = await CourseModel.getTotalCompletedLessons();
    } catch (error) {
      console.error('加载统计数据失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  async loadWeeklyData() {
    try {
      const records = await CheckinModel.getCheckins();
      const today = new Date();
      const weeklyData: Array<{ day: string; count: number }> = [];
      
      // 生成最近7天的数据
      for (let i = 6; i >= 0; i--) {
        const date = new Date(today);
        date.setDate(today.getDate() - i);
        const dateStr = this.formatDate(date);
        const dayName = this.getDayName(date.getDay());
        
        const dayRecords = records.filter(record => record.date === dateStr);
        const studyTime = dayRecords.reduce((total, record) => total + (record.studyTime || 0), 0);
        
        weeklyData.push({ day: dayName, count: studyTime });
      }
      
      this.weeklyData = weeklyData;
    } catch (error) {
      console.error('加载周数据失败:', error);
    }
  }

  formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  getDayName(day: number): string {
    const dayNames = ['日', '一', '二', '三', '四', '五', '六'];
    return `周${dayNames[day]}`;
  }

  build() {
    Column() {
      Text('学习统计')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40, bottom: 30 })

      // 统计卡片
      if (this.isLoading) {
        Text('加载中...')
          .fontSize(16)
          .color('#666')
      } else {
        Row({
          space: 15
        }) {
          Column({
            space: 5
          }) {
            Text('总打卡天数')
              .fontSize(14)
              .color('#666')
            Text(`${this.totalDays}`)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
          }
          .width('45%')
          .height(100)
          .backgroundColor('#F5F5F5')
          .borderRadius(10)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Column({
            space: 5
          }) {
            Text('连续打卡')
              .fontSize(14)
              .color('#666')
            Text(`${this.consecutiveDays}`)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
          }
          .width('45%')
          .height(100)
          .backgroundColor('#F5F5F5')
          .borderRadius(10)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .width('90%')
        .margin({ bottom: 15 })

        Row({
          space: 15
        }) {
          Column({
            space: 5
          }) {
            Text('总学习时长')
              .fontSize(14)
              .color('#666')
            Text(`${Math.floor(this.totalStudyTime / 60)}小时${this.totalStudyTime % 60}分钟`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
          }
          .width('45%')
          .height(100)
          .backgroundColor('#F5F5F5')
          .borderRadius(10)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Column({
            space: 5
          }) {
            Text('完成课程')
              .fontSize(14)
              .color('#666')
            Text(`${this.completedLessons}`)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
          }
          .width('45%')
          .height(100)
          .backgroundColor('#F5F5F5')
          .borderRadius(10)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .width('90%')
        .margin({ bottom: 30 })

        // 学习趋势
        Text('学习趋势')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 15 })

        // 学习趋势图表
        Column() {
          // 柱状图
          Row({
            space: 10
          }) {
            ForEach(this.weeklyData, (item) => {
              Column({
                space: 5
              }) {
                Stack() {
                  // 背景柱
                  Column()
                    .width(30)
                    .height(100)
                    .backgroundColor('#E5E5E5')
                    .borderRadius(4)
                  // 数据柱
                  Column()
                    .width(30)
                    .height(item.count > 0 ? Math.min(100, (item.count / 120) * 100) : 0) // 假设最大学习时间为120分钟
                    .backgroundColor('#007AFF')
                    .borderRadius(4)
                    .alignSelf(ItemAlign.End)
                }
                .height(100)
                .alignItems(HorizontalAlign.Center)
                Text(item.day)
                  .fontSize(12)
                  .color('#666')
              }
            })
          }
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: 20 })

          Text('最近7天学习时长（分钟）')
            .fontSize(14)
            .color('#666')
        }
        .width('90%')
        .flexGrow(1)
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}