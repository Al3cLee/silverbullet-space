中文版 README 请参见：https://wentaoli.xyz/README_ZH

This is the [GitHub repository](https://github.com/Al3cLee/silverbullet-space) for my knowledge garden, created with [Silverbullet](https://silverbullet.md/).

The recommended way to access this knowledge garden is via

* https://wentaoli.xyz

where a read-only instance of this website is hosted. The initial loading might take a little while, but after that, this website will remain accessible even without internet connection.

Alternatively, you can also access this knowledge garden off-line. This would be helpful if the loading or full-text search is slow: on your `localhost` things run much quicker.

To provide a minimal example:

First, you need to download the SilverBullet binary from [here](https://github.com/silverbulletmd/silverbullet/releases). Choose the binary file according to the operating system of your computer: 

* `darwin-aarch64` means MacOS with Apple M-series chip
* `darwin-x86_64` means MacOS with Intel chip
* `linux-aarch64` means linux with ARM chip
* `linux-x86_64` means linux with Intel/AMD chip
* `window-x86_64` means Windows with Intel/AMD chip.

You can also consult [this post](https://itsfoss.com/arm-aarch64-x86_64/) if confused.

Let us say you have your SilverBullet binary file unzip-ed and located at the location `<YourSilverBullet>`.

Then, execute the following commands:

```bash
git clone https://github.com/Al3cLee/silverbullet-space
<YourSilverBullet> silverbullet-space --port 3000
```

and open `http://localhost:3000` in your browser. This should bring you to an interface similar to what you see at the read-only website https://wentaoli.xyz.

In your own browser, however, you can do whatever editing you like! And because the files are on _your_ disk, you can use your own tools to interact with them. Tell your [opencode](https://opencode.ai) or other coding agent to translate them? Convert them to the format you prefer, or import them to your own note-taking app? The choice is yours.

See also the official documentation on [installation](https://silverbullet.md/Install/Binary) and [configuration](https://silverbullet.md/Install/Configuration).