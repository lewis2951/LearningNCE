export class StorageService {
  /**
   * 保存数据到Preferences
   * @param storeName 存储名称
   * @param key 键
   * @param value 值
   */
  static async saveData(storeName: string, key: string, value: any): Promise<boolean> {
    try {
      const preferences = await preferences.getPreferences(globalThis.abilityContext, storeName);
      const stringValue = typeof value === 'string' ? value : JSON.stringify(value);
      await preferences.put(key, stringValue);
      await preferences.flush();
      return true;
    } catch (error) {
      console.error('保存数据失败:', error);
      return false;
    }
  }

  /**
   * 从Preferences获取数据
   * @param storeName 存储名称
   * @param key 键
   * @param defaultValue 默认值
   */
  static async getData<T>(storeName: string, key: string, defaultValue: T): Promise<T> {
    try {
      const preferences = await preferences.getPreferences(globalThis.abilityContext, storeName);
      const value = await preferences.get(key, '');
      
      if (value === '') {
        return defaultValue;
      }
      
      // 尝试解析JSON
      try {
        return JSON.parse(value) as T;
      } catch {
        // 如果不是JSON，直接返回
        return value as unknown as T;
      }
    } catch (error) {
      console.error('获取数据失败:', error);
      return defaultValue;
    }
  }

  /**
   * 删除数据
   * @param storeName 存储名称
   * @param key 键
   */
  static async deleteData(storeName: string, key: string): Promise<boolean> {
    try {
      const preferences = await preferences.getPreferences(globalThis.abilityContext, storeName);
      await preferences.delete(key);
      await preferences.flush();
      return true;
    } catch (error) {
      console.error('删除数据失败:', error);
      return false;
    }
  }

  /**
   * 清除所有数据
   * @param storeName 存储名称
   */
  static async clearAllData(storeName: string): Promise<boolean> {
    try {
      const preferences = await preferences.getPreferences(globalThis.abilityContext, storeName);
      await preferences.clear();
      await preferences.flush();
      return true;
    } catch (error) {
      console.error('清除数据失败:', error);
      return false;
    }
  }
}

// 导入preferences模块
import preferences from '@ohos.data.preferences';
