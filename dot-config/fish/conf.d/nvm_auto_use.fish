# Auto use Node version from .nvmrc on directory change
if string match -q -- $hostname press
    function __nvm_use_on_cd --on-variable PWD --description "Use nvm version from .nvmrc"
        if test -f .nvmrc
            set -l nvmrc_version (cat .nvmrc | string trim)
            nvm use --silent $nvmrc_version 2>/dev/null
        end
    end

    # Also check on shell startup
    function __nvm_use_on_startup --on-event fish_prompt
        functions --erase __nvm_use_on_startup

        if test -f .nvmrc
            set -l nvmrc_version (cat .nvmrc | string trim)
            nvm use --silent $nvmrc_version 2>/dev/null
        end
    end
end
