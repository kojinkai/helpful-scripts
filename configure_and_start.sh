#!/usr/bin/env bash
function configure {

  function selectBuildTool {
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"  
    echo " Select your preferred installed build tool"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1. yarn"
    echo "2. npm"
  }

  function readBuildTool {
    local buildTool
    local suggestedBuildTool="yarn"

    read -p "Enter preferred build tool [1 or 2] " buildTool
    case $buildTool in
      1) tool=yarn ;;
      2) tool=npm ;;
      *) echo -e "${RED}Error...${STD}" && sleep 2
    esac

    tool=${tool:-$suggestedBuildTool}
  }

  function promptForApiKey {
    echo -n "enter your API_KEY: "
    read API_KEY
  }

  function writeSetupScript {
    touch start.sh
    printf "export API_KEY=${API_KEY}" > start.sh
    printf "\n$tool run start" >> start.sh
    chmod u+x start.sh
  }

  function runSetup {
    echo "installing project dependencies with $tool"
    `$tool install`

    echo "embedding your API Key into the start process"
    ./start.sh
  }

  while [ -z ${API_KEY+x} ]
  do
    selectBuildTool
    readBuildTool
    promptForApiKey
    writeSetupScript
    runSetup
  done
}

configure