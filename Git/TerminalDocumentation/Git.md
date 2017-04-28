# Motivation
This document aims to provide the most usual git commands and ways to use them in order to maintain a clear git history.

- What is a clear git history ?
- A clear git history is one that shows all the branch merges even after you pushed your changes. It does not hide your work, it reveals it so you can understand where new features are added.
This comes against cherry picking, vanishing merged branches, rebases that override merges and all that "good stuff".

This acts also as a git cheat sheet for those terminal commands that one so often forgets how to put together.

### Check out which branch tracks what
```terminal
$ git branch -vv   # doubly verbose!
```

### Push new branch to remote
```terminal
$ git push -u origin <branch>
```
is the same as:
```
git push origin <branch> ; git branch --set-upstream <branch> origin/<branch>
```

### Pull rebase (for pulling changes from remote to it's local counterpart)
```terminal
$ git fetch origin  
$ git rebase -p
```

### Merge
```terminal
$ git merge --no-ff
```

## Removing branches locally
```terminal
$ git branch -d <branch>
```

## Removing branches remotely
```terminal
$ git push origin :<branch>
```

## List all the remote branches
```terminal
$ git branch -r 				
```

## Stashes
+ git stash list
+ git stash pop
* git stash apply stash@{2}
* git stash drop stash@{0}

## When in doubt use the manual
```terminal
$ git command --help
```

## GIT Compound Commands:
* git pull == git fetch && git merge


# Advanced (not often used)

## Link a local repo with a remote

```terminal
$ git remote add origin <remote_repo_url>
$ git push --all origin
```

## Generate a .mailmap

```
git shortlog -se | \
  awk -F'\t' '{print $2,$3,$2,$3}' | \
  sort > .mailmap
```

## Force push new history upstream

```terminal
$ git push --force-with-lease
```

## Reset to commit hash

```terminal
$ git reset --hard 0d1d7fc32

$ git reset --hard HEAD
```


# The story of rebase
## Pull rebase recreates the hashes for the local commits
## it does not preserve the history in time of the commits
## just places the local commits on top of the remote ones
### MOTIVATION: when pulling the same branch from origin to local it
### displays the branch nicely instead of looking like it merged from the branch to itself

# Usage
*$git rebase --onto target-branch source-branch*

- target-branch means "branch you want to be based on"
- source-branch means "commit before your first feature commit"

Expl: $ git rebase --onto feature master

**This is equivalent to: $ git checkout feature && git rebase master **

---------------
*$ git pull develop origin/develop*
*Pulling from a branch on to itself creates a time loop in the git history. It looks like the same branch collapsed up on itself. We don't want that.*
```terminal
.
              origin/develop
                    |        
          +−−−− (E)−−−−(F)−−−−−−−−−−−−−−−−
         /                                \
(A) −− (B) −−−−−−−−(C) −− (D)−−−−(G − merge commit)  
                             |          
                           develop
```
*$git pull --rebase origin/develop develop*
*So in order to keep a neat git history we use rebase when pulling from a remote branch to it's local counterpart.*
```
--(A) −− (B)−−−−−−−|(E) −− (F)|−−−−−−−|(C') −− (D')|
                   |--ORIGIN--|       |---LOCAL----|
```
* git pull --rebase

Rebasing Deletes Merge Commits! because it rewrites unpushed commits.
This is okay if you do not have any local merge commits.

-----------------------------------------------------
*WITH PULL REBASE (merge commits disappeared)*
```terminal
(A) −− (B) −−−−−−(C)−−−(D)−−−−(I)−−−−(J)−−−−(E')−−−−−(F')−−−−−(G')−−−−  
        \                             |                        |         
         \                      origin/develop             develop
          \
            −−−−−−−−(E)−−−−(F)−−−−(G)
                                   |          
                          feature/TMS−123/myCoolFeature
```

------------- WITH REBASE -p (merge commits are preserved, DESIRED) --------------
```
                          origin/develop                 develop  
                                |                           |          
           +−−−− (C)−−−−(D)−−−−−−−(I)−−−−−(J)−−−−−−−−(H' − Merging completed Feature for TMS−123)
          /                                                        /      
(A) −− (B) −−−−−−−−(E)−−−−(F)−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−(G)  
                                                       |          
                                        feature/TMS−123/myCoolFeature
```
* git fetch origin  
* git rebase -p

# The story of merge
## Merging, preferred when finishing off a feature branch into master
## --no-ff creates the structure below that keeps track of where the commits come from

``` Preffered
$ git merge --no-ff master feature
--(A) −− (B)−−−−−−− (E) −− (F) −−−------------------(H Merge message)---   (master)
                                \                  /                      
                                 +--- (C) − (D) --                         (feature)  
```

``` Not Preffered
* git merge master feature
--(A) −− (B)−−−−−−− (E) −− (F) −−−(C) − (D)----   (master)
```
The history is lost, the branch never existed, sadness spreads all around space time.
