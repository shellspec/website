#!/bin/sh

i=1
while [ "$i" -le "${1:-10}" ]; do
  if expr "$i" % 15 = 0 >/dev/null; then
    echo "FizzBuzz"
  elif expr "$i" % 3 = 0 >/dev/null; then
    echo "Fizz"
  elif expr "$i" % 5 = 0 >/dev/null; then
    echo "Buzz"
  else
    echo "$i"
  fi
  i=$((i+1))
done
