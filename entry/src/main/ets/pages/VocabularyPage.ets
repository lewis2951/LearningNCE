import { Vocabulary, VocabularyModel } from '../model/VocabularyModel';
import promptAction from '@ohos.promptAction';
import { SliderStyle } from '@ohos/components';

@Entry
@Component
struct VocabularyPage {
  @State vocabularyList: Vocabulary[] = [];
  @State isLoading: boolean = true;
  @State showAddDialog: boolean = false;
  @State editingVocab: Vocabulary | null = null;
  @State word: string = '';
  @State meaning: string = '';
  @State example: string = '';

  aboutToAppear() {
    this.loadVocabulary();
  }

  async loadVocabulary() {
    this.isLoading = true;
    try {
      const vocabList = await VocabularyModel.getVocabularyList();
      // 按更新时间排序，最新的在前面
      vocabList.sort((a, b) => b.updatedAt - a.updatedAt);
      this.vocabularyList = vocabList;
    } catch (error) {
      console.error('加载生词失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  async handleAddVocabulary() {
    if (!this.word.trim()) {
      await promptAction.showToast({ message: '请输入单词' });
      return;
    }
    if (!this.meaning.trim()) {
      await promptAction.showToast({ message: '请输入释义' });
      return;
    }

    const vocab: Vocabulary = {
      id: Date.now().toString(),
      word: this.word,
      meaning: this.meaning,
      example: this.example,
      createdAt: Date.now(),
      updatedAt: Date.now(),
      mastery: 0
    };

    await VocabularyModel.saveVocabulary(vocab);
    await this.loadVocabulary();
    this.resetForm();
    this.showAddDialog = false;
  }

  async handleEditVocabulary() {
    if (!this.editingVocab) return;
    if (!this.word.trim()) {
      await promptAction.showToast({ message: '请输入单词' });
      return;
    }
    if (!this.meaning.trim()) {
      await promptAction.showToast({ message: '请输入释义' });
      return;
    }

    const updatedVocab: Vocabulary = {
      ...this.editingVocab,
      word: this.word,
      meaning: this.meaning,
      example: this.example,
      updatedAt: Date.now()
    };

    await VocabularyModel.saveVocabulary(updatedVocab);
    await this.loadVocabulary();
    this.resetForm();
    this.showAddDialog = false;
  }

  async handleDeleteVocabulary(id: string) {
    const result = await promptAction.showConfirm({
      message: '确定要删除这个生词吗？',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    });

    if (result && result.result) {
      await VocabularyModel.deleteVocabulary(id);
      await this.loadVocabulary();
    }
  }

  async handleUpdateMastery(id: string, mastery: number) {
    await VocabularyModel.updateMastery(id, mastery);
    await this.loadVocabulary();
  }

  resetForm() {
    this.word = '';
    this.meaning = '';
    this.example = '';
    this.editingVocab = null;
  }

  openEditDialog(vocab: Vocabulary) {
    this.editingVocab = vocab;
    this.word = vocab.word;
    this.meaning = vocab.meaning;
    this.example = vocab.example || '';
    this.showAddDialog = true;
  }

  build() {
    Column() {
      Text('生词本')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40, bottom: 20 })

      // 添加生词按钮
      Button('添加生词')
        .width('90%')
        .height(45)
        .fontSize(16)
        .backgroundColor('#007AFF')
        .margin({ bottom: 20 })
        .onClick(() => {
          this.resetForm();
          this.showAddDialog = true;
        })

      // 生词列表
      if (this.isLoading) {
        Text('加载中...')
          .fontSize(16)
          .color('#666')
      } else if (this.vocabularyList.length === 0) {
        Text('暂无生词')
          .fontSize(16)
          .color('#666')
      } else {
        List() {
          ForEach(this.vocabularyList, (vocab) => {
            ListItem() {
              Column({
                space: 10
              }) {
                Row({
                  space: 10
                }) {
                  Column({
                    space: 5
                  }) {
                    Text(vocab.word)
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)
                    Text(vocab.meaning)
                      .fontSize(14)
                      .color('#666')
                    if (vocab.example) {
                      Text(`例句: ${vocab.example}`)
                        .fontSize(12)
                        .color('#999')
                    }
                  }
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
                        this.openEditDialog(vocab);
                      })
                    Button('删除')
                      .width(60)
                      .height(30)
                      .fontSize(12)
                      .backgroundColor('#FF3B30')
                      .onClick(() => {
                        this.handleDeleteVocabulary(vocab.id);
                      })
                  }
                }
                // 掌握程度
                Row({
                  space: 10
                }) {
                  Text('掌握程度:')
                    .fontSize(14)
                    .color('#666')
                  Slider({
                    value: vocab.mastery,
                    min: 0,
                    max: 100,
                    step: 10,
                    style: SliderStyle.OutSet
                  })
                    .width('70%')
                    .height(40)
                    .onChange((value: number) => {
                      this.handleUpdateMastery(vocab.id, value);
                    })
                  Text(`${vocab.mastery}%`)
                    .fontSize(14)
                    .color('#666')
                    .width(40)
                    .textAlign(TextAlign.End)
                }
                .width('100%')
              }
              .padding(15)
              .borderBottom({ width: 1, color: '#E5E5E5' })
            }
          })
        }
        .width('90%')
        .flexGrow(1)
      }

      // 添加/编辑生词对话框
      if (this.showAddDialog) {
        Column({
          space: 20
        }) {
          Text(this.editingVocab ? '编辑生词' : '添加生词')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)

          // 单词输入
          Column({
            space: 5
          }) {
            Text('单词')
              .fontSize(14)
              .color('#666')
              .width('100%')
              .textAlign(TextAlign.Start)
            TextInput({
              placeholder: '请输入单词'
            })
              .width('100%')
              .height(45)
              .fontSize(16)
              .border({ width: 1, color: '#E5E5E5' })
              .borderRadius(8)
              .padding({ left: 15, right: 15 })
              .textAlign(TextAlign.Start)
              .onChange((value: string) => {
                this.word = value;
              })
              .defaultValue(this.word)
          }

          // 释义输入
          Column({
            space: 5
          }) {
            Text('释义')
              .fontSize(14)
              .color('#666')
              .width('100%')
              .textAlign(TextAlign.Start)
            TextInput({
              placeholder: '请输入释义'
            })
              .width('100%')
              .height(45)
              .fontSize(16)
              .border({ width: 1, color: '#E5E5E5' })
              .borderRadius(8)
              .padding({ left: 15, right: 15 })
              .textAlign(TextAlign.Start)
              .onChange((value: string) => {
                this.meaning = value;
              })
              .defaultValue(this.meaning)
          }

          // 例句输入
          Column({
            space: 5
          }) {
            Text('例句（可选）')
              .fontSize(14)
              .color('#666')
              .width('100%')
              .textAlign(TextAlign.Start)
            TextInput({
              placeholder: '请输入例句'
            })
              .width('100%')
              .height(45)
              .fontSize(16)
              .border({ width: 1, color: '#E5E5E5' })
              .borderRadius(8)
              .padding({ left: 15, right: 15 })
              .textAlign(TextAlign.Start)
              .onChange((value: string) => {
                this.example = value;
              })
              .defaultValue(this.example)
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
            Button(this.editingVocab ? '保存' : '添加')
              .width('48%')
              .height(45)
              .fontSize(16)
              .backgroundColor('#007AFF')
              .onClick(async () => {
                if (this.editingVocab) {
                  await this.handleEditVocabulary();
                } else {
                  await this.handleAddVocabulary();
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