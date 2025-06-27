This is the repository for my knowledge garden, created with  [Silverbullet](https://silverbullet.md/). The recommended way to access this knowledge garden is via `https://wentaoli.xyz`, where a read-only instance of this garden is hosted. This website will remain accessible even without internet connection if the initial loading was complete.

Alternatively, you can also access this knowledge garden off-line. This repository itself is a “[silverbullet space](https://silverbullet.md/Spaces)”, so [downloading](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github#downloading-a-repositorys-files) it to `<path>`, un-zipping it and passing `<path>` to Silverbullet as the argument will initiate a locally available web-app interface at `localhost:<port>` where `<port>` can be specified when you run Silverbullet. 

For details about installing Silverbullet and running it, see its documentation on [installation](https://silverbullet.md/Install/Binary) and [configuration](https://silverbullet.md/Install/Configuration). To provide a minimal example: if you have this repository at `<your-folder>` and installed the Silverbullet binary at `<your-path-to-silverbullet>`, then running 

```bash
SB_PORT=3000 <your-path-to-silverbullet> <your-folder>
```

and opening `http://localhost:3000` in your browser should give you an editable instance of the same knowledge garden as the one at `https://wentaoli.xyz`. 