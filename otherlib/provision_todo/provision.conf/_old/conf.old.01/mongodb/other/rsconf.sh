#!/bin/bash

sleep 10 | echo "Mx Sleeping"
# Plays script
mongo mogoodb://mongo-rs0-1:27017 rsconf.js


# https://www.youtube.com/watch?v=mlw7vWISaF4