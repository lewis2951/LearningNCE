import notificationManager from '@ohos.notificationManager';
import { BusinessError } from '@ohos.base';

export class NotificationService {
  private static readonly NOTIFICATION_ID = 1001;

  /**
   * 检查通知权限
   */
  static async checkNotificationPermission(): Promise<boolean> {
    try {
      const hasPermission = await notificationManager.requestEnableNotification();
      return hasPermission === 0;
    } catch (error) {
      console.error('检查通知权限失败:', error);
      return false;
    }
  }

  /**
   * 设置学习提醒
   * @param hour 小时
   * @param minute 分钟
   */
  static async setStudyReminder(hour: number, minute: number): Promise<boolean> {
    try {
      // 检查通知权限
      const hasPermission = await this.checkNotificationPermission();
      if (!hasPermission) {
        console.error('没有通知权限');
        return false;
      }

      // 取消之前的提醒
      await this.cancelStudyReminder();

      // 创建通知内容
      const notificationContent = {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: '学习提醒',
          text: '该学习新概念英语了！',
          additionalText: '坚持学习，提升英语水平'
        }
      };

      // 计算下次提醒时间
      const now = new Date();
      const reminderTime = new Date();
      reminderTime.setHours(hour, minute, 0, 0);

      // 如果时间已过，设置为明天
      if (reminderTime.getTime() <= now.getTime()) {
        reminderTime.setDate(reminderTime.getDate() + 1);
      }

      // 计算延迟时间（毫秒）
      const delay = reminderTime.getTime() - now.getTime();

      // 创建通知请求
      const notificationRequest = {
        id: this.NOTIFICATION_ID,
        content: notificationContent,
        deliveryTime: Date.now() + delay,
        autoCancel: true,
        groupName: 'study_reminder',
        groupId: 'study_reminder_group'
      };

      // 发送通知
      await notificationManager.publish(notificationRequest);
      console.log('学习提醒设置成功');
      return true;
    } catch (error) {
      console.error('设置学习提醒失败:', error);
      return false;
    }
  }

  /**
   * 取消学习提醒
   */
  static async cancelStudyReminder(): Promise<boolean> {
    try {
      await notificationManager.cancel(this.NOTIFICATION_ID);
      console.log('学习提醒已取消');
      return true;
    } catch (error) {
      console.error('取消学习提醒失败:', error);
      return false;
    }
  }

  /**
   * 发送即时通知
   * @param title 标题
   * @param content 内容
   */
  static async sendNotification(title: string, content: string): Promise<boolean> {
    try {
      // 检查通知权限
      const hasPermission = await this.checkNotificationPermission();
      if (!hasPermission) {
        console.error('没有通知权限');
        return false;
      }

      // 创建通知内容
      const notificationContent = {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title,
          text: content
        }
      };

      // 创建通知请求
      const notificationRequest = {
        id: Date.now(), // 使用时间戳作为ID，确保唯一
        content: notificationContent,
        autoCancel: true
      };

      // 发送通知
      await notificationManager.publish(notificationRequest);
      console.log('通知发送成功');
      return true;
    } catch (error) {
      console.error('发送通知失败:', error);
      return false;
    }
  }
}
