import { InputType } from '@ohos.input';

@Entry
@Component
struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  @State isLoading: boolean = false;
  @State errorMessage: string = '';

  build() {
    Column({
      space: 20
    }) {
      Text('登录')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 60, bottom: 40 })

      if (this.errorMessage) {
        Text(this.errorMessage)
          .fontSize(14)
          .color('#FF3B30')
          .textAlign(TextAlign.Center)
      }

      // 用户名输入
      Column({
        space: 5
      }) {
        Text('用户名')
          .fontSize(14)
          .color('#666')
          .width('90%')
          .textAlign(TextAlign.Start)
        TextInput({
          placeholder: '请输入用户名'
        })
          .width('90%')
          .height(50)
          .fontSize(16)
          .border({ width: 1, color: '#E5E5E5' })
          .borderRadius(8)
          .padding({ left: 15, right: 15 })
          .onChange((value: string) => {
            this.username = value;
            this.errorMessage = '';
          })
      }

      // 密码输入
      Column({
        space: 5
      }) {
        Text('密码')
          .fontSize(14)
          .color('#666')
          .width('90%')
          .textAlign(TextAlign.Start)
        TextInput({
          placeholder: '请输入密码',
          type: InputType.Password
        })
          .width('90%')
          .height(50)
          .fontSize(16)
          .border({ width: 1, color: '#E5E5E5' })
          .borderRadius(8)
          .padding({ left: 15, right: 15 })
          .onChange((value: string) => {
            this.password = value;
            this.errorMessage = '';
          })
      }

      // 登录按钮
      Button('登录')
        .width('90%')
        .height(50)
        .fontSize(18)
        .backgroundColor('#007AFF')
        .margin({ top: 30 })
        .onClick(async () => {
          await this.handleLogin();
        })

      // 注册链接
      Row() {
        Text('还没有账号？')
          .fontSize(14)
          .color('#666')
        Text('立即注册')
          .fontSize(14)
          .color('#007AFF')
          .onClick(() => {
            // TODO: 跳转到注册页面
          })
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }

  async handleLogin() {
    if (!this.username || !this.password) {
      this.errorMessage = '请输入用户名和密码';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    try {
      // 模拟登录验证
      // 实际应用中应该与后端验证或本地存储验证
      await new Promise(resolve => setTimeout(resolve, 1000));

      // 简单验证：用户名和密码不为空
      if (this.username && this.password) {
        // TODO: 保存登录状态
        console.log('登录成功');
        // 跳转到首页
      } else {
        this.errorMessage = '用户名或密码错误';
      }
    } catch (error) {
      this.errorMessage = '登录失败，请重试';
      console.error('登录失败:', error);
    } finally {
      this.isLoading = false;
    }
  }
}