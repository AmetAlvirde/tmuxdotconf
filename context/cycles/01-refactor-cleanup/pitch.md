Problem: Future maintainers cannot safely evolve the tmux configuration because
theme selection, theme layout, tmux hooks, and verification are coupled through
duplicated files and ad hoc checks. Who: Maintainers of this tmux configuration.

Gap: The current repository works, but it does not provide clear boundaries or a
repeatable safety check for behavior-preserving cleanup. Distinction: The cycle
treats the dotfiles repository as a small product whose structure should make
future tmux changes local, observable, and low-risk. Form / access surface:

Maintainers encounter the cycle through `context/cycles/01-refactor-cleanup/`,
then apply changes through `tmux.conf`, theme files, the theme switcher, and a
verification harness.
