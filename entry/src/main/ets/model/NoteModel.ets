export interface Note {
  id: string;
  title: string;
  content: string;
  createdAt: number;
  updatedAt: number;
  lessonId?: number; // 关联的课程ID
  book?: number; // 关联的册数
}

export class NoteModel {
  private static readonly STORAGE_KEY = 'notes';

  /**
   * 保存笔记
   * @param note 笔记
   */
  static async saveNote(note: Note): Promise<void> {
    try {
      const notes = await this.getNotes();
      const existingIndex = notes.findIndex(item => item.id === note.id);
      
      if (existingIndex >= 0) {
        // 更新现有笔记
        notes[existingIndex] = note;
      } else {
        // 添加新笔记
        notes.push(note);
      }
      
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'note');
      await preferences.put(this.STORAGE_KEY, JSON.stringify(notes));
      await preferences.flush();
    } catch (error) {
      console.error('保存笔记失败:', error);
    }
  }

  /**
   * 获取所有笔记
   * @returns 笔记列表
   */
  static async getNotes(): Promise<Note[]> {
    try {
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'note');
      const notesStr = await preferences.get(this.STORAGE_KEY, '');
      return notesStr ? JSON.parse(notesStr) : [];
    } catch (error) {
      console.error('获取笔记失败:', error);
      return [];
    }
  }

  /**
   * 获取指定ID的笔记
   * @param id 笔记ID
   * @returns 笔记
   */
  static async getNoteById(id: string): Promise<Note | null> {
    try {
      const notes = await this.getNotes();
      return notes.find(item => item.id === id) || null;
    } catch (error) {
      console.error('获取笔记失败:', error);
      return null;
    }
  }

  /**
   * 删除笔记
   * @param id 笔记ID
   */
  static async deleteNote(id: string): Promise<void> {
    try {
      const notes = await this.getNotes();
      const filteredNotes = notes.filter(item => item.id !== id);
      
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'note');
      await preferences.put(this.STORAGE_KEY, JSON.stringify(filteredNotes));
      await preferences.flush();
    } catch (error) {
      console.error('删除笔记失败:', error);
    }
  }

  /**
   * 获取指定课程的笔记
   * @param book 册数
   * @param lessonId 课程ID
   * @returns 笔记列表
   */
  static async getNotesByLesson(book: number, lessonId: number): Promise<Note[]> {
    try {
      const notes = await this.getNotes();
      return notes.filter(item => item.book === book && item.lessonId === lessonId);
    } catch (error) {
      console.error('获取课程笔记失败:', error);
      return [];
    }
  }
}

// 导入preferences模块
import preferences from '@ohos.data.preferences';
