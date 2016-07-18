function mkeuler-haskell -a project -d 'Start solving a euler problem with a haskell project'
    cd ~/src/euler
    mkdir -p $project
    cd $project
    if not test -d haskell
        set name "euler"$project
        stack new $name simple; and mv $name haskell
    end
    cd haskell
    e src/Main.hs
end
