function jd
<<<<<<< Updated upstream
    cd (fd -d 4 -t d . ~/src | fzf)
||||||| Stash base
    cd (fd -t d . ~/src | fzf)
=======
    cd (fd -t d -d 2 . ~/src | fzf)
>>>>>>> Stashed changes
end
