function tag {
  
  # cat package.json and filter version number, adding a v so we get v1.1.5, say
  local suggestedTagName=v`cat package.json | grep version | sed  "s/^.*: \"//;s/\".*//"`

  # prompt for tag name
  echo -n "enter your tagname (defaults to $suggestedTagName): "
  read tagname

  # set tag as either default or what was entered
  tagname=${tagname:-$suggestedTagName}
  echo "tag set as $tagname"
  echo -n "enter your message: "

  # prompt for message
  read message  
  echo "message set as $message"

  # grab upstream changes, tag and push but only if we're on master currently...
  if [ `git rev-parse --abbrev-ref HEAD` == "master" ]; then
    echo currently on master, rebasing and tagging...
    git pull --rebase origin master
    git tag -a $tagname -m "$message"
    git push origin $tagname
  else
    echo you are currently attempting to tag on `git rev-parse --abbrev-ref HEAD`
    echo "remove stale branches and re-run this script from master"
    exit 1
  fi
}