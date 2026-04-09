import { AuthService } from '../service/AuthService';
import { UserModel } from '../model/UserModel';
import { NotificationService } from '../service/NotificationService';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct ProfilePage {
  @State userName: string = '学习者';
  @State userAvatar: string = '';
  @State remindTime: string = '08:00';
  @State isLoggedIn: boolean = false;

  aboutToAppear() {
    this.loadUserInfo();
  }

  async loadUserInfo() {
    const isLoggedIn = await AuthService.isLoggedIn();
    this.isLoggedIn = isLoggedIn;
    
    if (isLoggedIn) {
      const user = await AuthService.getCurrentUser();
      if (user) {
        this.userName = user.name;
        this.userAvatar = user.avatar || '';
        this.remindTime = user.remindTime || '08:00';
      }
    }
  }

  build() {
    Column() {
      Text('个人中心')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40, bottom: 30 })

      // 用户信息
      Row({
        space: 15
      }) {
        Column() {
          Text('头像')
            .fontSize(14)
            .color('#666')
          Button(this.userAvatar ? '更换头像' : '上传头像')
            .width(80)
            .height(80)
            .fontSize(12)
            .backgroundColor('#E5E5E5')
        }
        
        Column({
          space: 10
        }) {
          Text(this.userName)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          if (this.isLoggedIn) {
            Button('编辑资料')
              .width(100)
              .height(30)
              .fontSize(12)
              .backgroundColor('#007AFF')
              .onClick(() => {
                // TODO: 跳转到编辑资料页面
              })
          } else {
            Button('登录/注册')
              .width(100)
              .height(30)
              .fontSize(12)
              .backgroundColor('#007AFF')
              .onClick(() => {
                // TODO: 跳转到登录页面
              })
          }
        }
      }
      .width('90%')
      .margin({ bottom: 30 })

      // 设置选项
      List() {
        ListItem() {
          Row({
            space: 10
          }) {
            Text('学习提醒')
              .fontSize(16)
              .flexGrow(1)
            Text(this.remindTime)
              .fontSize(14)
              .color('#666')
          }
          .padding(15)
          .borderBottom({ width: 1, color: '#E5E5E5' })
          .onClick(async () => {
            // 打开时间选择器
            const result = await promptAction.showTimePicker({
              hour: parseInt(this.remindTime.split(':')[0]),
              minute: parseInt(this.remindTime.split(':')[1]),
              is24Hour: true
            });
            
            if (result && result.result) {
              const { hour, minute } = result;
              const newTime = `${String(hour).padStart(2, '0')}:${String(minute).padStart(2, '0')}`;
              this.remindTime = newTime;
              
              // 保存提醒时间
              if (this.isLoggedIn) {
                await UserModel.updateUser({ remindTime: newTime });
              }
              
              // 设置学习提醒
              await NotificationService.setStudyReminder(hour, minute);
            }
          })
        }

        ListItem() {
          Row({
            space: 10
          }) {
            Text('学习笔记')
              .fontSize(16)
              .flexGrow(1)
            Text('查看')
              .fontSize(14)
              .color('#007AFF')
          }
          .padding(15)
          .borderBottom({ width: 1, color: '#E5E5E5' })
          .onClick(() => {
            // TODO: 跳转到笔记页面
          })
        }

        ListItem() {
          Row({
            space: 10
          }) {
            Text('生词本')
              .fontSize(16)
              .flexGrow(1)
            Text('查看')
              .fontSize(14)
              .color('#007AFF')
          }
          .padding(15)
          .borderBottom({ width: 1, color: '#E5E5E5' })
          .onClick(() => {
            // TODO: 跳转到生词本页面
          })
        }

        ListItem() {
          Row({
            space: 10
          }) {
            Text('关于应用')
              .fontSize(16)
              .flexGrow(1)
            Text('v1.0.0')
              .fontSize(14)
              .color('#666')
          }
          .padding(15)
          .borderBottom({ width: 1, color: '#E5E5E5' })
        }

        if (this.isLoggedIn) {
          ListItem() {
            Row() {
              Text('退出登录')
                .fontSize(16)
                .color('#FF3B30')
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .padding(15)
            .onClick(async () => {
              await AuthService.logout();
              this.isLoggedIn = false;
              this.userName = '学习者';
              this.userAvatar = '';
            })
          }
        }
      }
      .width('90%')
      .flexGrow(1)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}