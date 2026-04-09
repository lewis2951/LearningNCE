export interface Vocabulary {
  id: string;
  word: string;
  meaning: string;
  example?: string;
  createdAt: number;
  updatedAt: number;
  lessonId?: number; // 关联的课程ID
  book?: number; // 关联的册数
  mastery: number; // 掌握程度：0-100
}

export class VocabularyModel {
  private static readonly STORAGE_KEY = 'vocabulary';

  /**
   * 保存生词
   * @param vocab 生词
   */
  static async saveVocabulary(vocab: Vocabulary): Promise<void> {
    try {
      const vocabList = await this.getVocabularyList();
      const existingIndex = vocabList.findIndex(item => item.id === vocab.id);
      
      if (existingIndex >= 0) {
        // 更新现有生词
        vocabList[existingIndex] = vocab;
      } else {
        // 添加新生词
        vocabList.push(vocab);
      }
      
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'vocabulary');
      await preferences.put(this.STORAGE_KEY, JSON.stringify(vocabList));
      await preferences.flush();
    } catch (error) {
      console.error('保存生词失败:', error);
    }
  }

  /**
   * 获取所有生词
   * @returns 生词列表
   */
  static async getVocabularyList(): Promise<Vocabulary[]> {
    try {
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'vocabulary');
      const vocabStr = await preferences.get(this.STORAGE_KEY, '');
      return vocabStr ? JSON.parse(vocabStr) : [];
    } catch (error) {
      console.error('获取生词列表失败:', error);
      return [];
    }
  }

  /**
   * 获取指定ID的生词
   * @param id 生词ID
   * @returns 生词
   */
  static async getVocabularyById(id: string): Promise<Vocabulary | null> {
    try {
      const vocabList = await this.getVocabularyList();
      return vocabList.find(item => item.id === id) || null;
    } catch (error) {
      console.error('获取生词失败:', error);
      return null;
    }
  }

  /**
   * 删除生词
   * @param id 生词ID
   */
  static async deleteVocabulary(id: string): Promise<void> {
    try {
      const vocabList = await this.getVocabularyList();
      const filteredList = vocabList.filter(item => item.id !== id);
      
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'vocabulary');
      await preferences.put(this.STORAGE_KEY, JSON.stringify(filteredList));
      await preferences.flush();
    } catch (error) {
      console.error('删除生词失败:', error);
    }
  }

  /**
   * 获取指定课程的生词
   * @param book 册数
   * @param lessonId 课程ID
   * @returns 生词列表
   */
  static async getVocabularyByLesson(book: number, lessonId: number): Promise<Vocabulary[]> {
    try {
      const vocabList = await this.getVocabularyList();
      return vocabList.filter(item => item.book === book && item.lessonId === lessonId);
    } catch (error) {
      console.error('获取课程生词失败:', error);
      return [];
    }
  }

  /**
   * 更新生词掌握程度
   * @param id 生词ID
   * @param mastery 掌握程度
   */
  static async updateMastery(id: string, mastery: number): Promise<void> {
    try {
      const vocab = await this.getVocabularyById(id);
      if (vocab) {
        vocab.mastery = mastery;
        vocab.updatedAt = Date.now();
        await this.saveVocabulary(vocab);
      }
    } catch (error) {
      console.error('更新掌握程度失败:', error);
    }
  }
}

// 导入preferences模块
import preferences from '@ohos.data.preferences';
