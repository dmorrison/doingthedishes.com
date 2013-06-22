---
layout: post
title: Mercurial Versus Git (Kind Of)
---

There are many posts comparing Mercurial and Git, but here are the top
things I noticed recently when I used Mercurial for an extended amount
of time. Before that, I had come from a Git background.

- Git has a staging area and Mercurial doesn't. In Mercurial, when you modify files already in a repo, they're automatically added to the list of things that will be commited. In Git, you need to explicitly add these every time to the staging area.

- Branches in Mercurial and Git are different in a few important ways:
  
  - Mercurial tracks global commits (which can be on different branches), but
    Git tracks branches and the isolated commits inside these branches.
  - So, when you pull or push a Mercurial repository, you implicitly pull/push all branches.
  - In Mercurial, you "close" branches instead of deleting them (and they can be re-opened later at any time by just committing to them again). In Git, you actually delete branches. For Mercurial, this is good in that it preserves history, but, arguably, it's not as clean.

- Git's `checkout` is an overloaded, [Swiss Army knife](http://stevelosh.com/blog/2010/01/the-real-difference-between-mercurial-and-git/#the-big-difference), whereas Mercurial splits things into `hg branch`, `hg update`, and `hg revert`.

- The often-used `git pull` command combines two things (fetching and merging). In Mercurial, this shortcut command doesn't really exist. You need to do `hg pull` _and then_ an `hg update`. Though, you can do `hg pull -u` to achieve the same.

- Mercurial does garbage collection on a repository automatically when certain commands are called. Git makes you do it explicitly. I heard some people from GitHub at a recent presentation say that they get support tickets sometimes for people asking GitHub to do a `git gc` for them to try and magically fix certain problems.

- In Git, you can remove a stash/shelf with `git stash drop`, but it seems you can't do this in Mercurial. Though, shelves [are just stored as patches](http://stackoverflow.com/questions/10001017/hg-shelve-equivalent-of-git-stash-drop) under .hg/shelves, so you can remove a file there to delete a shelf.

- Mercurial is more lenient on the format used for the user name and the
  email settings, so things can, arguably, get messier in the commit log than with Git.

In the end, I actually enjoyed using Mercurial, and I can see where it's
perhaps better designed in several ways. However, the features of GitHub
versus BitBucket outweigh a lot of these factors.
