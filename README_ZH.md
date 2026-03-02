这是我的知识花园对应的 [GitHub 仓库](https://github.com/Al3cLee/silverbullet-space)，使用 [Silverbullet](https://silverbullet.md/) 创建。这也是我的个人主页。

若想访问这个知识花园，我推荐通过

* https://wentaoli.xyz

这里托管了该网站的只读实例。初始加载可能需要一点时间，但在此之后，即使没有互联网连接，该网站也将保持可访问状态。

你也可以离线访问这个知识花园。

让我提供一个最简单的例子：

首先，你需要从[这里](https://github.com/silverbulletmd/silverbullet/releases)下载 SilverBullet 的二进制文件。根据你的操作系统选择相应的二进制文件：

* `darwin-aarch64` 表示配备 Apple M 系列芯片的 MacOS
* `darwin-x86_64` 表示配备 Intel 芯片的 MacOS
* `linux-aarch64` 表示配备 ARM 芯片的 Linux
* `linux-x86_64` 表示配备 Intel/AMD 芯片的 Linux
* `window-x86_64` 表示配备 Intel/AMD 芯片的 Windows。

如果感到困惑，你也可以参考[这篇文章](https://itsfoss.com/arm-aarch64-x86_64/)。

假设你已将 SilverBullet 二进制文件解压并放置在 `<YourSilverBullet>` 的位置。

然后，执行以下命令：

```bash
git clone https://github.com/Al3cLee/silverbullet-space
<YourSilverBullet> silverbullet-space --port 3000
```

并在浏览器中打开 `http://localhost:3000`。这应该会为你呈现一个类似于你在网站 https://wentaoli.xyz 上看到的界面。

本地部署的好处是，在你自己的浏览器中，你可以进行编辑，而不仅仅是浏览。并且由于这些文件在 _你_ 的磁盘上，你可以使用你自己的工具与它们进行交互。让你的 [opencode](https://opencode.ai) 或其他编程助手（coding agent）来翻译它们？将它们转换为你喜欢的格式，或者将它们导入到你自己的笔记应用中？都没问题。

另请参阅关于[安装](https://silverbullet.md/Install/Binary)和[配置](https://silverbullet.md/Install/Configuration)的官方文档。
