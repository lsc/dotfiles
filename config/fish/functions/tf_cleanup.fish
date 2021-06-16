function tf_cleanup
    find . -type d -name '.terraform' -exec rm -rf {} \;
end

