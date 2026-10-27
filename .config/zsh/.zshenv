# Quando o zsh inicia com ZDOTDIR já herdado (ex.: painéis/tabs do herdr,
# que herdam o ambiente do `herdr server`), ele lê $ZDOTDIR/.zshenv e ignora
# ~/.zshenv. Delegamos para ~/.zshenv para que envs e .zshenv.secret sejam
# sempre recarregados em cada novo shell.
[[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"
