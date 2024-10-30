#!/bin/sh

export JAVA_HOME="/usr/lib/jvm/java-11-openjdk/"
export PATH="/usr/lib/jvm/java-11-openjdk/bin/:$PATH"

clojure "$@"
