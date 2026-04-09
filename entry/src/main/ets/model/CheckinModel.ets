export interface Checkin {
  id: string;
  date: string; // 格式：YYYY-MM-DD
  timestamp: number;
  studyTime?: number; // 学习时长（分钟）
  notes?: string; // 学习笔记
}

export class CheckinModel {
  private static readonly STORAGE_KEY = 'checkin_records';

  /**
   * 保存打卡记录
   * @param checkin 打卡记录
   */
  static async saveCheckin(checkin: Checkin): Promise<void> {
    try {
      const records = await this.getCheckins();
      const existingIndex = records.findIndex(item => item.date === checkin.date);
      
      if (existingIndex >= 0) {
        // 更新现有记录
        records[existingIndex] = checkin;
      } else {
        // 添加新记录
        records.push(checkin);
      }
      
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'checkin');
      await preferences.put(this.STORAGE_KEY, JSON.stringify(records));
      await preferences.flush();
    } catch (error) {
      console.error('保存打卡记录失败:', error);
    }
  }

  /**
   * 获取所有打卡记录
   * @returns 打卡记录列表
   */
  static async getCheckins(): Promise<Checkin[]> {
    try {
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'checkin');
      const recordsStr = await preferences.get(this.STORAGE_KEY, '');
      return recordsStr ? JSON.parse(recordsStr) : [];
    } catch (error) {
      console.error('获取打卡记录失败:', error);
      return [];
    }
  }

  /**
   * 获取指定日期的打卡记录
   * @param date 日期（YYYY-MM-DD）
   * @returns 打卡记录
   */
  static async getCheckinByDate(date: string): Promise<Checkin | null> {
    try {
      const records = await this.getCheckins();
      return records.find(item => item.date === date) || null;
    } catch (error) {
      console.error('获取打卡记录失败:', error);
      return null;
    }
  }

  /**
   * 获取连续打卡天数
   * @returns 连续打卡天数
   */
  static async getConsecutiveDays(): Promise<number> {
    try {
      const records = await this.getCheckins();
      if (records.length === 0) return 0;

      // 按日期排序（从新到旧）
      records.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());

      let consecutiveDays = 0;
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      for (let i = 0; i < records.length; i++) {
        const checkinDate = new Date(records[i].date);
        checkinDate.setHours(0, 0, 0, 0);
        
        const expectedDate = new Date(today);
        expectedDate.setDate(today.getDate() - consecutiveDays);
        
        if (checkinDate.getTime() === expectedDate.getTime()) {
          consecutiveDays++;
        } else {
          break;
        }
      }

      return consecutiveDays;
    } catch (error) {
      console.error('计算连续打卡天数失败:', error);
      return 0;
    }
  }

  /**
   * 获取总打卡天数
   * @returns 总打卡天数
   */
  static async getTotalCheckinDays(): Promise<number> {
    try {
      const records = await this.getCheckins();
      return records.length;
    } catch (error) {
      console.error('获取总打卡天数失败:', error);
      return 0;
    }
  }

  /**
   * 删除打卡记录
   * @param date 日期（YYYY-MM-DD）
   */
  static async deleteCheckin(date: string): Promise<void> {
    try {
      const records = await this.getCheckins();
      const filteredRecords = records.filter(item => item.date !== date);
      
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'checkin');
      await preferences.put(this.STORAGE_KEY, JSON.stringify(filteredRecords));
      await preferences.flush();
    } catch (error) {
      console.error('删除打卡记录失败:', error);
    }
  }
}

// 导入preferences模块
import preferences from '@ohos.data.preferences';
