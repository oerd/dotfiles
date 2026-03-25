OS=$(uname -s)
ARCH=$(uname -m)

if [[ "$OS" == "Darwin" ]]; then
  # macOS (Apple Silicon vs. Intel)
  if [[ "$ARCH" == "arm64" ]] || [[ $(uname -p) == "arm" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
  else
    export PATH="/usr/local/bin:$PATH"
  fi

elif [[ "$OS" == "Linux" ]]; then
  # Linux (ARM64 vs. AMD64)
  if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
    # Linux ARM path (e.g., AWS Graviton, Raspberry Pi)
    export PATH="/usr/local/bin:$PATH" # Replace with your specific Linux ARM path
  elif [[ "$ARCH" == "x86_64" ]]; then
    # Linux AMD64 path
    export PATH="/usr/local/bin:$PATH" # Replace with your specific Linux AMD64 path
  else
    echo "Unsupported Linux architecture: $ARCH"
  fi
fi
