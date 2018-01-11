#!/usr/bin/env bash
port=$1
function getPidByPort {
  # gets Process IDs running on a port
  lsof -i tcp:$port
}

getPidByPort