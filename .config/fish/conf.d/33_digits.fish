if string match -q -- $hostname press
    # This is adapted from our ~/.zshrc configuration

    set --global --export GCP_ACCOUNT_EMAIL phil@digits.com
    set --global --export DIGITS_REPO_PATH /Users/phildenhoff/digits

    # Add Homebrew
    fish_add_path /opt/homebrew/bin
    set --global --export HOMEBREW_PREFIX /opt/homebrew

    # Java
    set --global --export JAVA_HOME /Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home
    ## and its cousin Gradle
    set --global --export GRADLE_USER_HOME ~/.gradle

    # Go
    fish_add_path /Users/phildenhoff/go/bin

    # pnpm
    fish_add_path /Users/phildenhoff/Library/pnpm
end
