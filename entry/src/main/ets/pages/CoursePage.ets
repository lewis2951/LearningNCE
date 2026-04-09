import { Course, Lesson, CourseModel } from '../model/CourseModel';
import { ProgressType } from '@ohos/components';

@Entry
@Component
struct CoursePage {
  @State selectedBook: number = 1;
  @State course: Course | null = null;
  @State isLoading: boolean = true;

  aboutToAppear() {
    this.loadCourseData(this.selectedBook);
  }

  async loadCourseData(book: number) {
    this.isLoading = true;
    try {
      const courseData = await CourseModel.getCourse(book);
      this.course = courseData;
    } catch (error) {
      console.error('加载课程数据失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  async handleMarkCompleted(lessonId: number, completed: boolean) {
    if (!this.course) return;

    await CourseModel.markLessonCompleted(this.selectedBook, lessonId, completed);
    // 重新加载数据以更新UI
    await this.loadCourseData(this.selectedBook);
  }

  build() {
    Column() {
      Text('课程管理')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40, bottom: 20 })

      // 选择册数
      Row({
        space: 10
      }) {
        ForEach([1, 2, 3, 4], (book) => {
          Button(`第${book}册`)
            .width('22%')
            .height(40)
            .fontSize(14)
            .backgroundColor(this.selectedBook === book ? '#007AFF' : '#E5E5E5')
            .onClick(async () => {
              this.selectedBook = book;
              await this.loadCourseData(book);
            })
        })
      }
      .width('90%')
      .margin({ bottom: 20 })

      // 进度条
      if (this.course) {
        Row({
          space: 10
        }) {
          Text(`完成进度: ${this.course.progress}%`)
            .fontSize(14)
            .color('#666')
            .flexGrow(1)
        }
        .width('90%')
        .margin({ bottom: 10 })

        Progress({
          value: this.course.progress,
          total: 100,
          type: ProgressType.Linear
        })
        .width('90%')
        .height(8)
        .color('#007AFF')
        .margin({ bottom: 20 })
      }

      // 课程列表
      if (this.isLoading) {
        Text('加载中...')
          .fontSize(16)
          .color('#666')
      } else if (this.course) {
        List() {
          ForEach(this.course.lessons, (lesson) => {
            ListItem() {
              Row({
                space: 10
              }) {
                Text(lesson.title)
                  .fontSize(16)
                  .flexGrow(1)
                if (lesson.completed) {
                  Text('已完成')
                    .fontSize(14)
                    .color('#00C853')
                } else {
                  Button('标记完成')
                    .width(80)
                    .height(30)
                    .fontSize(12)
                    .backgroundColor('#007AFF')
                    .onClick(async () => {
                      await this.handleMarkCompleted(lesson.id, true);
                    })
                }
              }
              .padding(15)
              .borderBottom({ width: 1, color: '#E5E5E5' })
            }
          })
        }
        .width('90%')
        .flexGrow(1)
      } else {
        Text('加载课程数据失败')
          .fontSize(16)
          .color('#FF3B30')
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}