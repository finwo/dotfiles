#!bash

# Crash and verbose
set -ex

# cd to the right dir
cd $(dirname $0)
git init --bare $1

rm -rf $1/hooks/*.sample
cat << 'EOF' > "$1/hooks/post-receive"
#!/bin/sh

# Detect a force push
force=0
while read -r old new ref; do
  hasrevs=$(git rev-list "$old" "^$new" | sed 1q)
  if test -n "$hasrevs"; then
    force=1
    break
  fi
done

# Forward to other remotes
git remote | while read remote; do
  if test "$force" = "1"; then
    git push --force --all ${remote}
  else
    git push --all ${remote}
  fi
done
EOF

chmod +x "$1/hooks/post-receive"

# # Remove old data on force push
# if test "$force" = "1"; then
#   rm -rf archives
# fi

# # Build archives
# mkdir -p archives
# git for-each-ref --format="%(refname:short)" | while read -r ref; do
#   filename="archives/$(echo "${ref}" | tr '/' '_').tar.gz"
#   prefix=$(cat name | tr '/' '-')
#   git archive \
#     --format tar.gz \
#     --prefix "${prefix}-${ref}/" \
#     -o "${filename}" \
#     -- \
#     "${ref}"
# done

