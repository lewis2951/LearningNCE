# 新概念英语学习打卡应用设计文档

## 设计风格

- **主色调**：蓝色 (#007AFF) - 代表专业、信任和学习
- **辅助色**：绿色 (#4CD964) - 代表完成和成功
- **中性色**：灰色 (#E5E5E5, #666, #999) - 用于背景和文本
- **字体**：系统默认字体，清晰易读
- **布局**：移动端适配，响应式设计
- **交互**：流畅的动画效果，直观的操作反馈

## 页面设计

### 1. 首页

![首页设计](https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mobile%20app%20home%20page%20for%20English%20learning%20app%2C%20clean%20design%2C%20blue%20theme%2C%20welcome%20message%2C%20start%20learning%20button%2C%20course%20button%2C%20bottom%20navigation%20bar&image_size=portrait_16_9)

- **布局**：垂直居中布局
- **元素**：
  - 应用标题：「新概念英语学习」
  - 欢迎信息：「欢迎使用新概念英语学习打卡应用！」
  - 操作按钮：「开始学习」、「查看课程」
  - 底部导航栏：首页、打卡、课程、统计、我的

### 2. 打卡页面

![打卡页面设计](https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mobile%20app%20checkin%20page%2C%20daily%20checkin%20button%2C%20calendar%20view%2C%20date%20display%2C%20blue%20theme%2C%20mobile%20interface&image_size=portrait_16_9)

- **布局**：垂直布局
- **元素**：
  - 页面标题：「每日打卡」
  - 日期显示：「今日日期：YYYY-MM-DD」
  - 打卡按钮：「立即打卡」/「已打卡」
  - 打卡记录标题：「打卡记录」
  - 月份导航：上个月、当前月份、下个月
  - 日历视图：显示当月日期，已打卡日期标记为绿色

### 3. 课程页面

![课程页面设计](https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mobile%20app%20course%20page%2C%20book%20selection%20buttons%2C%20progress%20bar%2C%20lesson%20list%2C%20completed%20lessons%20marked%20green%2C%20blue%20theme%2C%20mobile%20interface&image_size=portrait_16_9)

- **布局**：垂直布局
- **元素**：
  - 页面标题：「课程管理」
  - 册数选择：「第1册」、「第2册」、「第3册」、「第4册」
  - 进度条：显示当前册的学习进度
  - 课程列表：显示课程标题和完成状态
  - 完成按钮：未完成的课程显示「标记完成」按钮

### 4. 统计页面

![统计页面设计](https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mobile%20app%20statistics%20page%2C%20data%20cards%2C%20learning%20trend%20chart%2C%20weekly%20data%2C%20blue%20theme%2C%20mobile%20interface&image_size=portrait_16_9)

- **布局**：垂直布局
- **元素**：
  - 页面标题：「学习统计」
  - 统计卡片：
    - 总打卡天数
    - 连续打卡天数
    - 总学习时长
    - 完成课程数
  - 学习趋势标题：「学习趋势」
  - 趋势图表：最近7天学习时长柱状图

### 5. 个人中心页面

![个人中心页面设计](https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mobile%20app%20profile%20page%2C%20user%20info%2C%20settings%20list%2C%20logout%20button%2C%20blue%20theme%2C%20mobile%20interface&image_size=portrait_16_9)

- **布局**：垂直布局
- **元素**：
  - 页面标题：「个人中心」
  - 用户信息：头像、用户名、编辑资料按钮
  - 设置选项：
    - 学习提醒时间设置
    - 学习笔记入口
    - 生词本入口
    - 关于应用
  - 退出登录按钮：仅在登录状态显示

### 6. 登录页面

![登录页面设计](https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mobile%20app%20login%20page%2C%20username%20input%2C%20password%20input%2C%20login%20button%2C%20register%20link%2C%20blue%20theme%2C%20mobile%20interface&image_size=portrait_16_9)

- **布局**：垂直居中布局
- **元素**：
  - 页面标题：「登录」
  - 用户名输入框：「请输入用户名」
  - 密码输入框：「请输入密码」
  - 登录按钮：「登录」
  - 注册链接：「还没有账号？立即注册」

### 7. 注册页面

![注册页面设计](https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mobile%20app%20register%20page%2C%20username%20input%2C%20password%20input%2C%20confirm%20password%20input%2C%20register%20button%2C%20login%20link%2C%20blue%20theme%2C%20mobile%20interface&image_size=portrait_16_9)

- **布局**：垂直居中布局
- **元素**：
  - 页面标题：「注册」
  - 用户名输入框：「请输入用户名」
  - 密码输入框：「请输入密码」
  - 确认密码输入框：「请再次输入密码」
  - 注册按钮：「注册」
  - 登录链接：「已有账号？立即登录」

### 8. 学习笔记页面

![学习笔记页面设计](https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mobile%20app%20notes%20page%2C%20add%20note%20button%2C%20note%20list%2C%20edit%20and%20delete%20buttons%2C%20blue%20theme%2C%20mobile%20interface&image_size=portrait_16_9)

- **布局**：垂直布局
- **元素**：
  - 页面标题：「学习笔记」
  - 添加笔记按钮：「添加笔记」
  - 笔记列表：显示笔记标题、内容预览、更新时间
  - 操作按钮：每条笔记显示「编辑」和「删除」按钮
  - 添加/编辑对话框：标题输入、内容输入、取消/保存按钮

### 9. 生词本页面

![生词本页面设计](https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mobile%20app%20vocabulary%20page%2C%20add%20word%20button%2C%20vocabulary%20list%2C%20mastery%20slider%2C%20edit%20and%20delete%20buttons%2C%20blue%20theme%2C%20mobile%20interface&image_size=portrait_16_9)

- **布局**：垂直布局
- **元素**：
  - 页面标题：「生词本」
  - 添加生词按钮：「添加生词」
  - 生词列表：显示单词、释义、例句（可选）
  - 掌握程度：滑块控件，0-100%
  - 操作按钮：每条生词显示「编辑」和「删除」按钮
  - 添加/编辑对话框：单词输入、释义输入、例句输入（可选）、取消/保存按钮

## 交互设计

### 1. 导航交互
- 底部导航栏点击切换页面
- 页面切换时使用平滑过渡动画

### 2. 打卡交互
- 点击「立即打卡」按钮后，按钮变为「已打卡」状态
- 打卡成功后，日历中对应日期变为绿色

### 3. 课程交互
- 点击册数按钮切换课程列表
- 点击「标记完成」按钮后，课程状态变为「已完成」
- 进度条实时更新

### 4. 统计交互
- 页面加载时显示加载动画
- 数据加载完成后平滑显示统计卡片和图表

### 5. 个人中心交互
- 点击「学习提醒」打开时间选择器
- 点击「学习笔记」和「生词本」跳转到对应页面
- 点击「退出登录」弹出确认对话框

### 6. 笔记和生词交互
- 点击「添加」按钮打开添加对话框
- 点击「编辑」按钮打开编辑对话框
- 点击「删除」按钮弹出确认对话框
- 生词本的掌握程度滑块拖动时实时更新

## 响应式设计

- 适配不同屏幕尺寸的HarmonyOS设备
- 布局会根据屏幕大小自动调整
- 字体大小和间距会根据屏幕尺寸优化

## 性能优化

- 使用懒加载技术，减少初始加载时间
- 优化数据存储和读取，提高应用响应速度
- 合理使用缓存，减少重复计算
- 优化UI渲染，确保流畅的用户体验

## 总结

本设计文档详细描述了新概念英语学习打卡应用的页面设计、交互设计和视觉风格。应用采用蓝色主题，界面简洁明了，操作直观易用，为用户提供了一个高效、便捷的英语学习工具。