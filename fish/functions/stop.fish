function stop
    if count $argv >/dev/null
        command stop $argv
    else
        echo "BAM! You just shot yourself in the foot!"
        echo ""
        echo "Just kidding. I'm there for you… <3"
    end
end
