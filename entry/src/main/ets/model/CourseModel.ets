export interface Lesson {
  id: number;
  title: string;
  completed: boolean;
  completedAt?: number;
}

export interface Course {
  book: number; // 第几册
  lessons: Lesson[];
  progress: number; // 完成进度（百分比）
}

export class CourseModel {
  private static readonly STORAGE_KEY_PREFIX = 'course_book_';

  /**
   * 初始化课程数据
   * @param book 册数
   */
  static async initCourse(book: number): Promise<Course> {
    // 新概念英语每册有24课
    const lessons: Lesson[] = Array.from({ length: 24 }, (_, i) => ({
      id: i + 1,
      title: `Lesson ${i + 1}`,
      completed: false
    }));

    const course: Course = {
      book,
      lessons,
      progress: 0
    };

    await this.saveCourse(course);
    return course;
  }

  /**
   * 保存课程数据
   * @param course 课程数据
   */
  static async saveCourse(course: Course): Promise<void> {
    try {
      // 计算进度
      const completedCount = course.lessons.filter(lesson => lesson.completed).length;
      course.progress = Math.round((completedCount / course.lessons.length) * 100);

      const key = `${this.STORAGE_KEY_PREFIX}${course.book}`;
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'course');
      await preferences.put(key, JSON.stringify(course));
      await preferences.flush();
    } catch (error) {
      console.error('保存课程数据失败:', error);
    }
  }

  /**
   * 获取课程数据
   * @param book 册数
   * @returns 课程数据
   */
  static async getCourse(book: number): Promise<Course> {
    try {
      const key = `${this.STORAGE_KEY_PREFIX}${book}`;
      const preferences = await preferences.getPreferences(globalThis.abilityContext, 'course');
      const courseStr = await preferences.get(key, '');

      if (courseStr) {
        return JSON.parse(courseStr);
      } else {
        // 如果没有数据，初始化
        return this.initCourse(book);
      }
    } catch (error) {
      console.error('获取课程数据失败:', error);
      // 出错时初始化
      return this.initCourse(book);
    }
  }

  /**
   * 标记课程为完成
   * @param book 册数
   * @param lessonId 课程ID
   * @param completed 是否完成
   */
  static async markLessonCompleted(book: number, lessonId: number, completed: boolean): Promise<void> {
    try {
      const course = await this.getCourse(book);
      const lesson = course.lessons.find(item => item.id === lessonId);

      if (lesson) {
        lesson.completed = completed;
        if (completed) {
          lesson.completedAt = Date.now();
        } else {
          delete lesson.completedAt;
        }
        await this.saveCourse(course);
      }
    } catch (error) {
      console.error('标记课程完成状态失败:', error);
    }
  }

  /**
   * 获取已完成的课程数量
   * @param book 册数
   * @returns 已完成课程数量
   */
  static async getCompletedLessonsCount(book: number): Promise<number> {
    try {
      const course = await this.getCourse(book);
      return course.lessons.filter(lesson => lesson.completed).length;
    } catch (error) {
      console.error('获取已完成课程数量失败:', error);
      return 0;
    }
  }

  /**
   * 获取所有册的课程数据
   * @returns 所有课程数据
   */
  static async getAllCourses(): Promise<Course[]> {
    try {
      const courses: Course[] = [];
      for (let book = 1; book <= 4; book++) {
        const course = await this.getCourse(book);
        courses.push(course);
      }
      return courses;
    } catch (error) {
      console.error('获取所有课程数据失败:', error);
      return [];
    }
  }

  /**
   * 获取总完成课程数
   * @returns 总完成课程数
   */
  static async getTotalCompletedLessons(): Promise<number> {
    try {
      const courses = await this.getAllCourses();
      let totalCompleted = 0;
      courses.forEach(course => {
        totalCompleted += course.lessons.filter(lesson => lesson.completed).length;
      });
      return totalCompleted;
    } catch (error) {
      console.error('获取总完成课程数失败:', error);
      return 0;
    }
  }
}

// 导入preferences模块
import preferences from '@ohos.data.preferences';
