import { Checkin, CheckinModel } from '../model/CheckinModel';

@Entry
@Component
struct CheckinPage {
  @State isChecked: boolean = false;
  @State checkinDate: string = this.formatDate(new Date());
  @State checkinRecords: Checkin[] = [];
  @State currentMonth: number = new Date().getMonth();
  @State currentYear: number = new Date().getFullYear();

  aboutToAppear() {
    this.loadCheckinStatus();
    this.loadCheckinRecords();
  }

  async loadCheckinStatus() {
    const today = this.formatDate(new Date());
    const checkin = await CheckinModel.getCheckinByDate(today);
    this.isChecked = !!checkin;
  }

  async loadCheckinRecords() {
    const records = await CheckinModel.getCheckins();
    this.checkinRecords = records;
  }

  async handleCheckin() {
    if (this.isChecked) return;

    const checkin: Checkin = {
      id: Date.now().toString(),
      date: this.checkinDate,
      timestamp: Date.now(),
      studyTime: 30, // 默认学习30分钟
      notes: ''
    };

    await CheckinModel.saveCheckin(checkin);
    this.isChecked = true;
    await this.loadCheckinRecords();
  }

  formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  getDaysInMonth(year: number, month: number): number {
    return new Date(year, month + 1, 0).getDate();
  }

  getFirstDayOfMonth(year: number, month: number): number {
    return new Date(year, month, 1).getDay();
  }

  build() {
    Column({
      space: 20
    }) {
      Text('每日打卡')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })

      Text(`今日日期: ${this.checkinDate}`)
        .fontSize(16)

      Button(this.isChecked ? '已打卡' : '立即打卡')
        .width('80%')
        .height(50)
        .fontSize(18)
        .backgroundColor(this.isChecked ? '#999' : '#007AFF')
        .onClick(async () => {
          await this.handleCheckin();
        })

      Text('打卡记录')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })

      // 打卡日历视图
      Column() {
        // 月份导航
        Row({
          space: 20
        }) {
          Button('上个月')
            .width(80)
            .height(30)
            .fontSize(14)
            .onClick(() => {
              if (this.currentMonth === 0) {
                this.currentMonth = 11;
                this.currentYear--;
              } else {
                this.currentMonth--;
              }
            })

          Text(`${this.currentYear}年${this.currentMonth + 1}月`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)

          Button('下个月')
            .width(80)
            .height(30)
            .fontSize(14)
            .onClick(() => {
              if (this.currentMonth === 11) {
                this.currentMonth = 0;
                this.currentYear++;
              } else {
                this.currentMonth++;
              }
            })
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)

        // 星期标题
        Row({
          space: 0
        }) {
          ForEach(['日', '一', '二', '三', '四', '五', '六'], (day) => {
            Text(day)
              .width('14.28%')
              .textAlign(TextAlign.Center)
              .fontSize(14)
              .color('#666')
          })
        }
        .width('90%')

        // 日历网格
        Grid() {
          const daysInMonth = this.getDaysInMonth(this.currentYear, this.currentMonth);
          const firstDay = this.getFirstDayOfMonth(this.currentYear, this.currentMonth);

          // 空白占位
          for (let i = 0; i < firstDay; i++) {
            GridItem() {
              Text('')
            }
          }

          // 日期
          for (let day = 1; day <= daysInMonth; day++) {
            const dateStr = `${this.currentYear}-${String(this.currentMonth + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
            const isChecked = this.checkinRecords.some(record => record.date === dateStr);
            const isToday = dateStr === this.checkinDate;

            GridItem() {
              Text(`${day}`)
                .width('100%')
                .height(40)
                .textAlign(TextAlign.Center)
                .fontSize(16)
                .fontWeight(isToday ? FontWeight.Bold : FontWeight.Normal)
                .backgroundColor(isChecked ? '#4CD964' : isToday ? '#E3F2FD' : 'transparent')
                .borderRadius(isChecked ? 20 : 0)
            }
          }
        }
        .width('90%')
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
        .columnsGap(5)
        .rowsGap(5)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}