# Dotfiles

My dotfiles, cross-platform and managed with [chezmoi](https://chezmoi.io).

## Structure

This repository is structured to support multiple operating systems and Linux distributions dynamically.

-   `common/`: Contains configurations that are shared across all systems.
-   `darwin/`: Contains configurations specific to macOS (`darwin`).
-   `linux/`: Contains configurations specific to Linux.

### Linux Distributions

The `linux/` directory is further organized to support different distributions and custom profiles:

-   `linux/common/`: For configurations shared across all Linux distributions.
-   `linux/<distro-id>/`: For distribution-specific configurations (e.g., `linux/arch/`, `linux/ubuntu/`).
-   `linux/<profile-name>/`: For custom profiles.

### How it Works

The logic for applying the correct configurations is handled by the `.chezmoiignore` file at the root of the repository. This file uses `chezmoi`'s templating features to dynamically include and exclude directories based on the operating system and a custom `profile` variable.

On Linux systems, `chezmoi` will first check for a `profile` variable in your `~/.config/chezmoi/chezmoi.toml` file. If it's set, it will apply the corresponding profile directory. If not, it will fall back to applying the directory that matches the system's distribution ID.