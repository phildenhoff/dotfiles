if string match -q -- $hostname press.local
    # This is adapted from our ~/.zshrc configuration

    set -gx GCP_ACCOUNT_EMAIL phil@digits.com
    set -gx DIGITS_REPO_PATH /Users/phildenhoff/digits

    # Add Homebrew
    fish_add_path /opt/homebrew/bin
    set -gx HOMEBREW_PREFIX /opt/homebrew

    # Java
    set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home

    # Go
    fish_add_path /Users/phildenhoff/go/bin
end
