function mkeuler-rust -a project -d 'Start solving a euler problem with a rust project'
    cd ~/src/euler
    mkdir -p $project
    cd $project
    if not test -d rust
        cargo new --bin $project; and mv $project rust
    end
    cd rust
    ec src/main.rs
end
