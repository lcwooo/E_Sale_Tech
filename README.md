# E_Sale_Tech

NLE new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

/lib/api common为公共接口放置的文件，在对应的名称下面进行api添加，如views/goods页面的接口，就需要写在同名文件里面

/lib/components 公共组件，如果有重复组件，就抽离到这个文件夹下面，文件名称命名需要规范，一看就知道是用到哪里的

/lib/event 事件分发

/lib/I10n 国际化，vscode下载 "Flutter Intl" 插件，修改I10n对应的国家语言之后会在generated文件夹下自动生成刚才添加的键值对，generated文件夹不要修改

/lib/model 接口数据具体的定义，通过fromJson来定义之后可以在对象里面直接获取到有哪些属性

/lib/routers 页面路由

/lib/utils 通用的工具之类, 例如style里面有全局定义的一些颜色、文本大小等等
