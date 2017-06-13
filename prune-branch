function cleanup {
  local cleanupBranch=`git rev-parse --abbrev-ref HEAD`
  git checkout master
  git pull --rebase
  git branch -D $cleanupBranch
  git remote prune origin
  return
}

cleanup