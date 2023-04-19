# Setups neovim with lazyvim and AI plugins
NEW_USER=${1:-$USER}

if [ -d "/home/$NEW_USER/.config/nvim" ]; then
	echo "nvim config already exists"
	echo "moving to nvim.bak"
	mv /home/$NEW_USER/.config/nvim /home/$NEW_USER/.config/nvim.bak
	mv /home/$NEW_USER/.cache/nvim /home/$NEW_USER/.cache/nvim.bak
	mv /home/$NEW_USER/.local/share/nvim /home/$NEW_USER/.local/share/nvim.bak
fi

git clone https://github.com/LazyVim/starter /home/$NEW_USER/.config/nvim
rm -rf ~/.config/nvim/.git

cp copilot.lua /home/$NEW_USER/.config/nvim/lua/plugins
cp chatgpt.lua /home/$NEW_USER/.config/nvim/lua/plugins
