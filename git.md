---
tags: 
- "computer-science/tool"
- "computer-science/missing-semester"
finished: true
---

# Git

This note roughly follows the [Missing Semester lecture note from MIT](https://missing.csail.mit.edu/2020/version-control/).

Version control systems (VCSs) allow the user to

* jump between later and earlier _versions_ of the project, and
* develop multiple _branches_ in parallel then _merge_ them together.

Doing these with plain text files require backing up every version and every branch on disk, which is tedious for both individual and collaborative work. This can be alleviated by manipulating _labels instead of files_; manipulations of on-disk files are to be _automated_ by VCSs.

Git is a command-line VCS (run `git help <command>` to learn about `<command>`). It provides a systematic way of manipulating labels and automating the version-control-related editing of on-disk files. Git also facilitates efficient collaboration.

## Data structure

The data structure of Git consists of two layers:

* on-disk objects, e.g. folders or files, and
* references, which are _dynamic labels_ pointing to objects.

Objects are always associated with a unique, fixed label known as the SHA-1 Hash string. From the data structure point of view, an object and its SHA-1 Hash belong to the same layer.

There is a default reference `HEAD` which points to the snapshot that the user is currently working with. If the user is only making new edits and not looking back, `HEAD` would be always pointing to the latest commit. 

The key difference between the two layers of data is that references are dynamic, while objects and their Hash strings are fixed. The dynamic layer is the key to Git’s vast power.

---

Git is initialized in a folder via running `git init` inside it. This folder is known as a Git _repository_. After that, all activity in the repository will be monitored by Git, with exceptions set in the [`.gitignore`](https://git-scm.com/docs/gitignore) file.

The data structure of git centers around _commits_. A commit consists of

* files on disk (known as “blobs” in Git terminology),
* folder structures on disk (known as “trees”),
* parent(s) of the commit, and
* other metadata, e.g. date, time, user.

The files and folder structures mentioned above are all captured at the moment of commit, so a Git commit is like a snapshot.

Typically, the user starts from some commit(s), carries out some operations, and then captures the snapshot as a new commit. The starting point(s) are called the _parent(s)_ of the current commit. A commit can have multiple parents if it was produced by merging many commits together and making edits, see [[git#Branching and merging]].

---

One way to visualize the data structure of Git is via diagrams, where each commit is represented by a letter, and parent relations are indicated by lines. Such diagrams are often used for illustrative purposes in the manuals invoked via `git help`; a diagram-like history of the project is available via `git log --graph`. For example, in the manual invoked via `git help merge` we see the following diagram

```
          A---B---C topic
         /
    D---E---F---G master
```

where each capital letter is shorthand for the Hash string of a commit, and a reference can point to one of them, e.g. `HEAD=G`. There are two _branches_ in this git diagram, called `master` and `topic`, respectively. 

## Linear version control

The (linear) workflow of git version control is 

* before committing, make edits and `git add <files-to-add>`;
* commit the `add`ed files via `git commit`;
* jump to some commit `<commit-name>` with `git checkout <commit-name>`. The `<commit-name>` can either be a Hash string (available via `git log`) or a reference.

In the first step, `git add` puts edited files into the staging area, and `git commit` will _only_ commit files in this area. This allows the user to manually select the files to be committed, which is useful when some files exist in the folder but do not belong to this particular commit for some reason, e.g. two developments are available for commit, but one needs further testing, so only the other is committed.

The command `git checkout <commit-name>` affects both layers in the data structure. It changes on-disk files into the version `<commit-name>` and redirects the reference `HEAD` to `<commit-name>`.

## Branching and merging

A _branch_ is a reference that automatically re-directs to the latest commit. For example, upon `git init` a default branch `main` will be created, and as edits are committed, `main` will update itself and point to the latest commit.

Note that it is easy to confuse the technical meaning of “branch” with its intuitive meaning which is a “line of development” among many parallel ones. In what follows we will use “line of development” to express the intuitive meaning of “branch”, and reserve “branch” exclusively for the exact, technical meaning in the context of Git.

Without Git, to develop two functionalities `X` and `Y` in parallel we would have to make two directories `project-X` and `project-Y` on-disk and develop in these folders; after both modules are developed we manually merge `project-X` and `project-Y` into a single folder.

This approach needs two local folders. In general, without Git, the local storage needed for parallel development would be proportional to the number of parallel projects, which is inefficient. Besides, manually merging many folders can be difficult.

---

Instead of storing many folders simultaneously, Git stores _only one folder and many references._ It assigns a reference to each line of development so that the user can switch between lines of development easily, _as if they are all present on-disk_. This reference that corresponds to a line of development is the _branch_ defined earlier.

Proceeding with our previous example, for two lines of development `X` and `Y`, Git will construct two references `branch-X` and `branch-Y`, both pointing to the current commit. 

Now, “switching to a line of development” is realized by “summoning” one of the references to keep up, while the unsummoned references stay where they are. E.g., `git switch branch-X` will tell the reference `branch-X` that it should automatically update itself to keep up with all following commits. 

In the diagram below, each box represents a folder. In the solution without Git, there are two on-disk folders (black), while in the solution with Git, at every step of development only one folder is on-disk (black), and the other is stored in Git’s memory (gray). A gray folder is _not_ on-disk, but Git knows how to produce it when needed. Note that `X0=Y0` because nothing has been added to either `X` or `Y`.

To switch the line of development from `X` to `Y`, Git 

* deletes the folder `X1` and produces `Y0` on-disk, thus turning `X1` gray and `Y0` black,
* tells `branch-X` to stay put, and
* summons the label `branch-Y` to keep up.
![git-vs-folder](/images/git-vs-folder.svg)

From the perspective of references and the objects they point to, the process is as follows; references are in blue and each box is a commit instead of folder.
![branching-and-merging](/images/branch-activity.svg)

With the branches all pointing to their respective lines of developments’ latest commit, the user can easily work with many parallel lines of development. On-disk files are automatically changed by git when the user `checkout`s at different branches.

Git can merge files automatically _when they are orthogonal_. Otherwise, Git will indicate the existence of a `merge conflict` and prompt the user to manually merge the conflicting files. Although Git is powerful, one should minimize the overlap of different lines of development to avoid merge conflicts.

## Remotes

A Git _remote_ is a repository that is connected (via `git remote add`) to some other repository. It can be either on the same machine as the connected repository or on the internet. Distributing the same project among several repositories facilitates syncing and collaboration. 

Note that a repository and its remote are “equally original”, there is no need to remember which repository is the original one. When `A` is a remote of `B`, `B` can also be a remote of `A`.

Most Git operations are carried out _within_ a repository, and communication between repositories use a separate set of Git tools. Conversely, such tools are _only capable of communication between repositories_, they do not provide any additional local Git operation.

---

Communication between a repository and its remotes happen on the level of branches. From one repository, Git can `pull` a branch from a remote or `push` a branch to it. This means all (nontrivial) commits on the branch are sent between repositories, so after sending a branch to a remote, version control of this branch becomes available on the remote. For the meaning of “nontrivial”, see Pro Git.

The workflow of working with a remote is then

* `git remote add` the remote so that the current repository becomes aware of the remote,
* `git push` some branch to the remote, or `git pull` from the remote,
* do whatever `git` operation needed locally,
* `git push` or `pull` the new commits to or from remotes.

Actually, `git push` and `git pull` does more than just sending data, e.g. `git pull` automatically fast-forwards the local branch if it is “behind” the remote branch. For details, see the [Git documentation](https://git-scm.com/doc).