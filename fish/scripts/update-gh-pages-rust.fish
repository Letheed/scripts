#!/usr/bin/fish
#
# In a git repository containing a rust crate,
# gererate the documentation with cargo doc,
# copy it over to the gh-pages branch and commit it.
#
# author: Letheed <dev@daweb.se>
#

# Parameters
set ignore_pattern "index\.html" # extended regexp of the files to keep
set commit_message "update crate documentation"


# Git repository root directory
set workdir (git rev-parse --show-toplevel)
set workdir "$workdir"

if not test -d $workdir
  exit
end

function is_dir_git_repository
  echo -n "git repository: "
  if not test -d ".git"
    echo "$workdir is not a git repository"
    return 1
  end
  echo "OK"
end

function is_dir_rust_crate
  echo -n "rust crate: "
  if not test -f Cargo.toml
    echo "$workdir is not a rust crate"
    return 1
  end
  echo "OK"
end

function run_cargo_clean
  echo -n "cargo clean: "
  if not cargo clean
    echo "failed"
    return 1
  end
  echo "done"
end

function run_cargo_build
  echo -n "cargo build: "
  if not cargo build >&-
    return 1
  end
  echo "pass"
end

function run_cargo_test
  echo -n "cargo test: "
  if not cargo test >&- ^&-
    echo "failed"
    return 1
  end
  echo "pass"
end

function run_cargo_doc
  echo -n "cargo doc: "
  if not cargo doc ^&-
    return 1
  end
  echo "done"
end

function update_doc
  echo -n "removing old doc: "
  if not /bin/rm -r .lock (/bin/ls -1 --color=never | grep -Ev $ignore_pattern)
    return 1
  end
  echo "done"
  echo -n "copying new doc: "
  if not cp -a ./target/doc/{*,.*} .
    return 1
  end
  echo "done"
end

function commit_changes
  echo "commiting changes:"
  git add .
  and git commit -m $commit_message
  return $status
end

# Keep the cargo target folder
if test -z $ignore_pattern
  set ignore_pattern "target"
else
  set ignore_pattern "target|"$ignore_pattern
end

cd $workdir
and is_dir_git_repository
and is_dir_rust_crate
and run_cargo_test
and run_cargo_clean
and run_cargo_doc
#and set initial_branch (git rev-parse --abbrev-ref HEAD)
and git checkout gh-pages >&-
and update_doc
and commit_changes
#and git checkout $initial_branch >&-
