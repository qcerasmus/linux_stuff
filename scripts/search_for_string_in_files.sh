if [ "$#" -ne 2 ]; then
  echo "provide search_string and path"
  return
fi
grep -w "$1" -r $2 2>/dev/null
