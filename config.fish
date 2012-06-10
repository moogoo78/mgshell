## ref: 
# https://wiki.archlinux.org/index.php/Fish#Configuration_Suggestions
set fish_git_dirty_color cyan

function parse_git_dirty 
         git diff --quiet HEAD ^&-
         if test $status = 1
            echo (set_color $fish_git_dirty_color)"☝"(set_color normal)
         end
end

function parse_git_branch
         # git branch outputs lines, the current branch is prefixed with a *
         #set -l branch (git branch --color ^&- | awk '/*/ {print $2}')
         set -l branch (git symbolic-ref HEAD | cut -c 12-)
         echo $branch (parse_git_dirty)     
end

function head_om
         echo (set_color magenta)'ॐ '(set_color normal)
end

function start_sign
         echo (set_color red)'⚡'(set_color normal)
end 

function fish_prompt
         if test -z (git branch --quiet 2>| awk '/fatal:/ {print "no git"}')
            #printf '%s@%s %s%s%s (%s) %s %s' (head_om) (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (parse_git_branch) (start_sign)            
            printf '%s %s%s%s (%s%s%s) %s' (head_om) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (set_color cyan) (parse_git_branch) (set_color normal) (start_sign)            
         else
            #printf '%s@%s %s%s%s %s %s' (head_om) (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (start_sign)
            printf '%s %s%s%s %s' (head_om) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (start_sign)
         end 
end

function p
         cd ..;ls;pwd;
end
