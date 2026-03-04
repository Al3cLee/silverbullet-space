这是我的知识花园对应的 [GitHub 仓库](https://github.com/Al3cLee/silverbullet-space)，使用 [Silverbullet](https://silverbullet.md/) 创建。

我推荐通过

* https://wentaoli.xyz

访问这个知识花园，那里托管了知识花园的一个只读实例。初始加载可能需要一点时间，但在此之后，即使你的设备没有联网，该网站也将保持可访问状态，因为必要的数据已经传输到了你的浏览器缓存。

你也可以离线访问这个知识花园，步骤如下。

首先，从[这里](https://github.com/silverbulletmd/silverbullet/releases)下载 SilverBullet 的二进制文件。根据你的操作系统选择相应的二进制文件：

* `darwin-aarch64` 表示配备 Apple M 系列芯片的 MacOS
* `darwin-x86_64` 表示配备 Intel 芯片的 MacOS
* `linux-aarch64` 表示配备 ARM 芯片的 Linux
* `linux-x86_64` 表示配备 Intel/AMD 芯片的 Linux
* `window-x86_64` 表示配备 Intel/AMD 芯片的 Windows。

假设你已将 SilverBullet 二进制文件解压并放置在 `<YourSilverBullet>` 的位置。

然后，在终端（MacOS: “终端”，Windows: “PowerShell”）执行以下命令：

```bash
git clone https://github.com/Al3cLee/silverbullet-space
<YourSilverBullet> silverbullet-space --port 3000
```

并在浏览器中打开 `http://localhost:3000`。这应该会是一个类似 https://wentaoli.xyz 的界面。

本地部署的好处是，在你自己的浏览器中，你可以进行编辑，而不仅仅是浏览。并且由于这些文件在 _你_ 的磁盘上，你可以使用你自己的工具与它们进行交互。让你的 [opencode](https://opencode.ai) 或其他编程助手（coding agent）来翻译它们？将它们转换为你喜欢的格式，或者将它们导入到你自己的笔记应用中？都没问题。

另请参阅 SilverBullet 关于[安装](https://silverbullet.md/Install/Binary)和[配置](https://silverbullet.md/Install/Configuration)的官方文档。
