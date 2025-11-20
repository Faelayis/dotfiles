os.setenv('STARSHIP_CONFIG', 'F:\\Github\\faelayis\\dotfiles\\starship\\starship.toml')

load(io.popen('starship init cmd'):read("*a"))()