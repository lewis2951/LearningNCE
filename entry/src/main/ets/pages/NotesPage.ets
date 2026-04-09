import { Note, NoteModel } from '../model/NoteModel';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct NotesPage {
  @State notes: Note[] = [];
  @State isLoading: boolean = true;
  @State showAddDialog: boolean = false;
  @State editingNote: Note | null = null;
  @State title: string = '';
  @State content: string = '';

  aboutToAppear() {
    this.loadNotes();
  }

  async loadNotes() {
    this.isLoading = true;
    try {
      const notesList = await NoteModel.getNotes();
      // 按更新时间排序，最新的在前面
      notesList.sort((a, b) => b.updatedAt - a.updatedAt);
      this.notes = notesList;
    } catch (error) {
      console.error('加载笔记失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  async handleAddNote() {
    if (!this.title.trim()) {
      await promptAction.showToast({ message: '请输入标题' });
      return;
    }

    const note: Note = {
      id: Date.now().toString(),
      title: this.title,
      content: this.content,
      createdAt: Date.now(),
      updatedAt: Date.now()
    };

    await NoteModel.saveNote(note);
    await this.loadNotes();
    this.resetForm();
    this.showAddDialog = false;
  }

  async handleEditNote() {
    if (!this.editingNote) return;
    if (!this.title.trim()) {
      await promptAction.showToast({ message: '请输入标题' });
      return;
    }

    const updatedNote: Note = {
      ...this.editingNote,
      title: this.title,
      content: this.content,
      updatedAt: Date.now()
    };

    await NoteModel.saveNote(updatedNote);
    await this.loadNotes();
    this.resetForm();
    this.showAddDialog = false;
  }

  async handleDeleteNote(id: string) {
    const result = await promptAction.showConfirm({
      message: '确定要删除这条笔记吗？',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    });

    if (result && result.result) {
      await NoteModel.deleteNote(id);
      await this.loadNotes();
    }
  }

  resetForm() {
    this.title = '';
    this.content = '';
    this.editingNote = null;
  }

  openEditDialog(note: Note) {
    this.editingNote = note;
    this.title = note.title;
    this.content = note.content;
    this.showAddDialog = true;
  }

  build() {
    Column() {
      Text('学习笔记')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40, bottom: 20 })

      // 添加笔记按钮
      Button('添加笔记')
        .width('90%')
        .height(45)
        .fontSize(16)
        .backgroundColor('#007AFF')
        .margin({ bottom: 20 })
        .onClick(() => {
          this.resetForm();
          this.showAddDialog = true;
        })

      // 笔记列表
      if (this.isLoading) {
        Text('加载中...')
          .fontSize(16)
          .color('#666')
      } else if (this.notes.length === 0) {
        Text('暂无笔记')
          .fontSize(16)
          .color('#666')
      } else {
        List() {
          ForEach(this.notes, (note) => {
            ListItem() {
              Column({
                space: 10
              }) {
                Row({
                  space: 10
                }) {
                  Text(note.title)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .flexGrow(1)
                  Row({
                    space: 10
                  }) {
                    Button('编辑')
                      .width(60)
                      .height(30)
                      .fontSize(12)
                      .backgroundColor('#E5E5E5')
                      .onClick(() => {
                        this.openEditDialog(note);
                      })
                    Button('删除')
                      .width(60)
                      .height(30)
                      .fontSize(12)
                      .backgroundColor('#FF3B30')
                      .onClick(() => {
                        this.handleDeleteNote(note.id);
                      })
                  }
                }
                Text(note.content)
                  .fontSize(14)
                  .color('#666')
                  .maxLines(3)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(new Date(note.updatedAt).toLocaleString())
                  .fontSize(12)
                  .color('#999')
                  .alignSelf(ItemAlign.End)
              }
              .padding(15)
              .borderBottom({ width: 1, color: '#E5E5E5' })
            }
          })
        }
        .width('90%')
        .flexGrow(1)
      }

      // 添加/编辑笔记对话框
      if (this.showAddDialog) {
        Column({
          space: 20
        }) {
          Text(this.editingNote ? '编辑笔记' : '添加笔记')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)

          // 标题输入
          Column({
            space: 5
          }) {
            Text('标题')
              .fontSize(14)
              .color('#666')
              .width('100%')
              .textAlign(TextAlign.Start)
            TextInput({
              placeholder: '请输入笔记标题'
            })
              .width('100%')
              .height(45)
              .fontSize(16)
              .border({ width: 1, color: '#E5E5E5' })
              .borderRadius(8)
              .padding({ left: 15, right: 15 })
              .textAlign(TextAlign.Start)
              .onChange((value: string) => {
                this.title = value;
              })
              .defaultValue(this.title)
          }

          // 内容输入
          Column({
            space: 5
          }) {
            Text('内容')
              .fontSize(14)
              .color('#666')
              .width('100%')
              .textAlign(TextAlign.Start)
            TextArea({
              placeholder: '请输入笔记内容'
            })
              .width('100%')
              .height(120)
              .fontSize(16)
              .border({ width: 1, color: '#E5E5E5' })
              .borderRadius(8)
              .padding({ left: 15, right: 15, top: 10, bottom: 10 })
              .textAlign(TextAlign.Start)
              .onChange((value: string) => {
                this.content = value;
              })
              .defaultValue(this.content)
          }

          // 按钮
          Row({
            space: 15
          }) {
            Button('取消')
              .width('48%')
              .height(45)
              .fontSize(16)
              .backgroundColor('#E5E5E5')
              .onClick(() => {
                this.showAddDialog = false;
                this.resetForm();
              })
            Button(this.editingNote ? '保存' : '添加')
              .width('48%')
              .height(45)
              .fontSize(16)
              .backgroundColor('#007AFF')
              .onClick(async () => {
                if (this.editingNote) {
                  await this.handleEditNote();
                } else {
                  await this.handleAddNote();
                }
              })
          }
          .width('100%')
        }
        .width('85%')
        .padding(20)
        .backgroundColor('#FFFFFF')
        .borderRadius(10)
        .position({ x: '50%', y: '50%' })
        .translate({ x: '-50%', y: '-50%' })
        .zIndex(999)
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(this.showAddDialog ? 'rgba(0, 0, 0, 0.5)' : '#FFFFFF')
  }
}