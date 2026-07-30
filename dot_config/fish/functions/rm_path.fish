function rm_path --argument path
    set path (path resolve $path)
    set path_index (contains -i $path $fish_user_paths)

    if test $status -ne 0
        echo $path not in fish_user_paths
        return 1
    end

    echo Removing $path at index $path_index from fish_user_paths

    set -e fish_user_paths[$path_index]
end
