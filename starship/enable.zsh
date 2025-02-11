# We want out prompt to change based on the system's theme.
# Override the 'starship' command for dynamic configuration.
function update_starship_config() {

# For macOS: "defaults read -g AppleInterfaceStyle" returns "Dark" in dark mode.
if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
    export STARSHIP_CONFIG="$HOME/.config/starship/starship-dark.toml"
else
    export STARSHIP_CONFIG="$HOME/.config/starship/starship-light.toml"
fi

}

# Add the function to the precmd hook so it runs before each prompt.
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_starship_config

# Now initialize starship.
eval "$(starship init zsh)"
