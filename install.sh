#/usr/bin/env bash

# Quick&Dirty install...

echo "if [ -f ~/.qlixed_term.bashrc ]; then
	. ~/.qlixed_term.bashrc
fi" >> $HOME/.bashrc

ln -s qlixed_term.bashrc $HOME/.qlixed_term.bashrc
mkdir -p $HOME/bin/
ln -s sshm.sh $HOME/bin/sshm
echo "Ready, just restart your terminal connections or run:

source ~/.qlixed_term.bashrc

for immediate effect.
For updates simple do a git pull and source again, all files are linked here"
