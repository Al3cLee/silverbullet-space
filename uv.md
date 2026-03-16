#computer-science/tool

## Introduction

`uv` is a blazing-fast environment manager for python. Here, “environment” means python **itself** and its packages. This means `uv` as a stand-alone piece of software can help you through everything from installing python and managing project dependency, virtual environments, and package management for `jupyter` notebooks.

The official documentation is great. In particular, they teach you how to [manage python version](https://docs.astral.sh/uv/guides/install-python/) and [work with projects](https://docs.astral.sh/uv/guides/projects/). Make sure to read these guides. One thing to add: to make your editor’s language server protocol aware of the virtual environment, run

```bash
source .venv/bin/activate
```

in your project root.

## Working with `jupyter` notebooks

Notebooks are not like normal plain-text code, in that once they are open, they are already “served” in some sense. Viewing plain-text code requires nothing but a text editor, but working with notebooks requires

* a web-application server frontend: “jupyter server”, and
* a backend which contains package management info and can run code: the “jupyter kernel”.

With `uv`, working with jupyter notebooks is easy. Remember to let `uv` take care of everything, i.e. jupyter notebooks should not be allowed as “outlaws” not governed by `uv`.

The jupyter tool should be added as a dependency. Assuming you already have a `uv` project, in its root run

```bash
uv add --dev ipykernel
```

But up to now, no kernel has been installed. With

```bash
uv run ipython kernel install --user --env VIRTUAL_ENV $(pwd)/.venv --name=<project>
```

you can install a jupyter kernel called `<project>`. Do **not** add any space before or after the `=` character! I.e. do not write stuff like `--name= myproject`.

Next comes the subtle part. How do we make sure everything in notebooks are aware of the packages installed via `uv`? For `.py` scripts, we always run them with `uv run`, so `.py` files are directly taken care of.

Notebooks are run by their kernel and served by the jupyter server. Therefore, we should make both kernels and the server aware of the `uv` virtual environment. Kernels are themselves intalled via `uv run ipython kernel install ...`, so they already know about the virtual environment. To make the server also aware of the virtual environment, we run it with

```bash
uv run --with jupyter \
jupyter lab
```

where, upon clicking the “select kernel” in the web UI, you can see a kernel called `<project>` that you installed previously.

In the notebook you can add packages via

```python
!uv add <package>
```

and `<package>` will _automatically_ be added to your virtual environment.

## Working with notebooks without kernels

It is indeed still possible to work with notebooks without any kernel, just run

```bash
uv run --with jupyter \
jupyter lab
```

after initializing the `uv` project.

In the browser session of jupyter notebook, you can select “connect to existing python kernel”. In the VS Code jupyter interface, select “Python environments” and a python environment with the same name as your `uv` project will be shown as “recommended”, select it. This “python kernel” or “python environment” is the backend responsible for environment management and running code.

Not having kernels disables adding packages from within the notebook with the syntax `!uv add <package>`; i.e., without kernels, notebooks only have read-only access to the virtual environment set up by `uv`. Any package imported in the notebook has to be installed via running `uv add` in the project root.