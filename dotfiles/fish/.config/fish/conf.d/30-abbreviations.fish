# Abreviações interativas do Fish

if status is-interactive
    # Navegação e arquivos
    if type -q eza
        abbr --add ls "eza --group-directories-first"
        abbr --add ll "eza --long --all --group-directories-first --git"
        abbr --add la "eza --all --group-directories-first"
        abbr --add lt "eza --tree --level=2 --group-directories-first"
    end

    # Git
    abbr --add g "git"
    abbr --add gs "git status"
    abbr --add ga "git add"
    abbr --add gaa "git add ."
    abbr --add gc "git commit"
    abbr --add gp "git push"
    abbr --add gl "git pull"
    abbr --add gb "git branch"
    abbr --add gco "git checkout"
    abbr --add gsw "git switch"
    abbr --add gd "git diff"

    # Utilitários
    abbr --add c "clear"
    abbr --add cls "clear"

    # Scripts Personalizados
    abbr --add checksetup "/home/david-no-linux/workstation/scripts/doctor.sh"
end
