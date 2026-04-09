export interface User {
  id: string;
  name: string;
  avatar?: string;
  remindTime?: string;
  createdAt: number;
  updatedAt: number;
}

export class UserModel {
  private static readonly STORAGE_KEY = 'user_info';

  /**
   * 保存用户信息
   * @param user 用户信息
   */
  static async saveUser(user: User): Promise<void> {
    try {
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'user');
      await preferences.put(this.STORAGE_KEY, JSON.stringify(user));
      await preferences.flush();
    } catch (error) {
      console.error('保存用户信息失败:', error);
    }
  }

  /**
   * 获取用户信息
   * @returns 用户信息
   */
  static async getUser(): Promise<User | null> {
    try {
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'user');
      const userStr = await preferences.get(this.STORAGE_KEY, '');
      return userStr ? JSON.parse(userStr) : null;
    } catch (error) {
      console.error('获取用户信息失败:', error);
      return null;
    }
  }

  /**
   * 更新用户信息
   * @param updates 更新的字段
   */
  static async updateUser(updates: Partial<User>): Promise<void> {
    try {
      const user = await this.getUser();
      if (user) {
        const updatedUser = {
          ...user,
          ...updates,
          updatedAt: Date.now()
        };
        await this.saveUser(updatedUser);
      }
    } catch (error) {
      console.error('更新用户信息失败:', error);
    }
  }

  /**
   * 删除用户信息
   */
  static async deleteUser(): Promise<void> {
    try {
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'user');
      await preferences.delete(this.STORAGE_KEY);
      await preferences.flush();
    } catch (error) {
      console.error('删除用户信息失败:', error);
    }
  }
}

// 导入preferences模块
import preferences from '@ohos.data.preferences';
