#!/usr/bin/env bash

function newBranch {

  # function to display menus
  function selectIssueType {
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~"  
    echo " ISSUE - TYPES"
    echo "~~~~~~~~~~~~~~~~~~~~~"
    echo "1. feature"
    echo "2. fix"
    echo "3. chore"
    echo "4. refactor"
    echo "5. test"
    echo "6. docs"
  }

  function readIssueInput {
    local issueType
    read -p "Enter issueType [1 - 5] " issueType
    case $issueType in
      1) prefix=feature ;;
      2) prefix=fix ;;
      3) prefix=chore ;;
      4) prefix=refactor ;;
      5) prefix=test ;;
      6) prefix=docs ;;
      *) echo -e "${RED}Error...${STD}" && sleep 2
    esac
  }

  # prompt for issue number
  function promptForIssueNumber {
    echo "now enter the JIRA issue: ENG-"
    read issueNumber
    jiraIssue="ENG-$issueNumber"
  }

  function promptForBranchDescription {
    echo -n "enter a terse branch description: "
    read branchDescription
  }

  function composeBranchMessage {
    # concatenate a branch name replacing any whitespace with a dash and piping to perl to convert to lowercase
    branchName=${prefix}/${jiraIssue}-$(echo "$branchDescription" | sed -E -e  "s/[[:blank:]]/-/g" | perl -ne 'print lc')
    echo ${branchName}
  }

  function getbaseBranch {
    if [ -z ${targetBranch+x} ]
      then
      targetBranch="development"
    fi
  }

  function checkoutNewBranch {
    echo "Creating a new branch from ${targetBranch} with your options..."
    git checkout ${targetBranch}
    git pull --rebase
    git checkout -b ${branchName}
  }

  while [ -z ${prefix+x} ]
  do
    selectIssueType
    readIssueInput
    promptForIssueNumber
    promptForBranchDescription
    composeBranchMessage
    getbaseBranch
    checkoutNewBranch
  done

}

while getopts ":b:" opt; do
  case $opt in
    b)
      echo "-b was triggered, Parameter: $OPTARG" >&2
      targetBranch=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

newBranch
