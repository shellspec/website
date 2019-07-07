add() {
  echo "$(($1 + $2))"
  sleep 0.2
}

sub() {
  echo "$(($1 - $2))"
  sleep 0.2
}

mul() {
  echo "$(($1 * $2))"
  sleep 0.2
}

div() {
  echo "$(($1 / $2))"
  sleep 0.2
}
