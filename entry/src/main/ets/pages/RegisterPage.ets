import { InputType } from '@ohos.input';

@Entry
@Component
struct RegisterPage {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State isLoading: boolean = false;
  @State errorMessage: string = '';

  build() {
    Column({
      space: 20
    }) {
      Text('注册')
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

      // 确认密码输入
      Column({
        space: 5
      }) {
        Text('确认密码')
          .fontSize(14)
          .color('#666')
          .width('90%')
          .textAlign(TextAlign.Start)
        TextInput({
          placeholder: '请再次输入密码',
          type: InputType.Password
        })
          .width('90%')
          .height(50)
          .fontSize(16)
          .border({ width: 1, color: '#E5E5E5' })
          .borderRadius(8)
          .padding({ left: 15, right: 15 })
          .onChange((value: string) => {
            this.confirmPassword = value;
            this.errorMessage = '';
          })
      }

      // 注册按钮
      Button('注册')
        .width('90%')
        .height(50)
        .fontSize(18)
        .backgroundColor('#007AFF')
        .margin({ top: 30 })
        .onClick(async () => {
          await this.handleRegister();
        })

      // 登录链接
      Row() {
        Text('已有账号？')
          .fontSize(14)
          .color('#666')
        Text('立即登录')
          .fontSize(14)
          .color('#007AFF')
          .onClick(() => {
            // TODO: 跳转到登录页面
          })
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }

  async handleRegister() {
    if (!this.username || !this.password || !this.confirmPassword) {
      this.errorMessage = '请填写所有字段';
      return;
    }

    if (this.password !== this.confirmPassword) {
      this.errorMessage = '两次输入的密码不一致';
      return;
    }

    if (this.password.length < 6) {
      this.errorMessage = '密码长度至少为6位';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    try {
      // 模拟注册验证
      // 实际应用中应该与后端验证或本地存储验证
      await new Promise(resolve => setTimeout(resolve, 1000));

      // 简单验证：用户名和密码不为空
      if (this.username && this.password) {
        // TODO: 保存用户信息
        console.log('注册成功');
        // 跳转到登录页面
      } else {
        this.errorMessage = '注册失败，请重试';
      }
    } catch (error) {
      this.errorMessage = '注册失败，请重试';
      console.error('注册失败:', error);
    } finally {
      this.isLoading = false;
    }
  }
}