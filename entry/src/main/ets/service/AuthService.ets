import { User, UserModel } from '../model/UserModel';
import { StorageService } from './StorageService';

export class AuthService {
  private static readonly TOKEN_KEY = 'auth_token';
  private static readonly USER_KEY = 'user_info';

  /**
   * 登录
   * @param username 用户名
   * @param password 密码
   * @returns 登录结果
   */
  static async login(username: string, password: string): Promise<boolean> {
    try {
      // 模拟登录验证
      // 实际应用中应该与后端API验证
      await new Promise(resolve => setTimeout(resolve, 1000));

      // 简单验证：用户名和密码不为空
      if (username && password) {
        // 生成模拟token
        const token = this.generateToken();
        
        // 保存token
        await StorageService.saveData('auth', this.TOKEN_KEY, token);
        
        // 保存用户信息
        const user: User = {
          id: Date.now().toString(),
          name: username,
          createdAt: Date.now(),
          updatedAt: Date.now()
        };
        await UserModel.saveUser(user);
        
        console.log('登录成功');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      console.error('登录失败:', error);
      return false;
    }
  }

  /**
   * 注册
   * @param username 用户名
   * @param password 密码
   * @returns 注册结果
   */
  static async register(username: string, password: string): Promise<boolean> {
    try {
      // 模拟注册验证
      // 实际应用中应该与后端API验证
      await new Promise(resolve => setTimeout(resolve, 1000));

      // 简单验证：用户名和密码不为空且密码长度>=6
      if (username && password && password.length >= 6) {
        console.log('注册成功');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      console.error('注册失败:', error);
      return false;
    }
  }

  /**
   * 登出
   */
  static async logout(): Promise<void> {
    try {
      // 清除token
      await StorageService.deleteData('auth', this.TOKEN_KEY);
      
      // 清除用户信息
      await UserModel.deleteUser();
      
      console.log('登出成功');
    } catch (error) {
      console.error('登出失败:', error);
    }
  }

  /**
   * 检查是否已登录
   * @returns 是否已登录
   */
  static async isLoggedIn(): Promise<boolean> {
    try {
      const token = await StorageService.getData<string>('auth', this.TOKEN_KEY, '');
      return !!token;
    } catch (error) {
      console.error('检查登录状态失败:', error);
      return false;
    }
  }

  /**
   * 获取当前用户
   * @returns 当前用户
   */
  static async getCurrentUser(): Promise<User | null> {
    try {
      return await UserModel.getUser();
    } catch (error) {
      console.error('获取当前用户失败:', error);
      return null;
    }
  }

  /**
   * 生成模拟token
   * @returns 模拟token
   */
  private static generateToken(): string {
    return 'token_' + Date.now() + '_' + Math.random().toString(36).substr(2);
  }
}
