#!/usr/bin/ruby -w

BEGIN {
	puts "Environment setup script v1.0"
}

HOME_FOLDER = "/Users/beral06"; # you should fix this, for sure.  'Cause that's kinda janky
DOWNLOADS_FOLDER = HOME_FOLDER + "/Downloads";
VIM_FOLDER = HOME_FOLDER + "/.vim";

SPECTACLE_URL = "https://s3.amazonaws.com/spectacle/downloads/Spectacle+1.0.6.zip";
NOTES_SYNTAX_URL = "https://github.com/abertrand13/notes-syntax.git";
SOLARIZED_VIM_URL = "git://github.com/altercation/vim-colors-solarized.git";

def printHeader(text)
	puts "";
	puts "+" + ("-" * (text.length+2)) + "+";	
	puts "| " + text + " |";
	puts "+" + ("-" * (text.length+2)) + "+";	
end

def printSubHeader(text)
	puts "";	
	puts text;
	puts ("-" * (text.length));
end

# need a printSubHeader (or like, print info?)
# we need a check as well to see if these things are installed?

printHeader("STEP SOMETHING :: Set zsh as default shell");
currentShell = `echo $SHELL`;
if currentShell.include?("zsh") then
	puts "Current shell is already set to zsh.  If it is not the default shell, you can change it with 'chsh -s $(which zsh)'";
else
	system "chsh -s $(which zsh)";
end

printHeader("STEP 1 :: Download HOMEBREW");
if not system "which brew > /dev/null" then
	# pipe to null to silence output	
	system 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
else
	puts "Homebrew already installed";
end

printHeader("STEP 2 :: Configure VIM");

printSubHeader("STEP 2a :: Install Pathogen");
if not File.file?("#{VIM_FOLDER}/autoload/pathogen.vim") then
	# install pathogen
	system "mkdir -p #{VIM_FOLDER}/autoload #{VIM_FOLDER}/bundle && \
	curl -LSso #{VIM_FOLDER}/autoload/pathogen.vim https://tpo.pe/pathogen.vim"
else
	puts "Pathogen already installed";
end


printSubHeader("STEP 2b :: Configure `.vimrc`");
# check status of vimrc
if File.file?("#{HOME_FOLDER}/.vimrc") then
	# check if vimrc contains the right line, prepend it if it doesn't
	if not File.read("#{HOME_FOLDER}/.vimrc").include?("execute pathogen#infect()") then
		system "echo 'execute pathogen#infect()' > #{HOME_FOLDER}/.vimrc";
	end
	puts "Pathogen triggered.  Moving on...";
else
	# download vimrc from a place
	puts "No .vimrc found, downloading..."
end

printSubHeader("STEP 2c :: Notes syntax");
# clone notes syntax plugin for vim
if not File.directory?("#{VIM_FOLDER}/bundle/notes-syntax") then
	system "cd #{VIM_FOLDER}/bundle && git clone " + NOTES_SYNTAX_URL;
else
	puts "Notes syntax plugin already installed."
	# update?
	# give option to update?	
end

printHeader("STEP SOMETHING :: Configure Oh-my-zsh");
printSubHeader("STEP :: Download antigen");
# git clone https://github.com/zsh-users/antigen.git

printHeader("STEP SOMETHING :: Solarized Theme for All the Things");
printSubHeader("Downloading solarized theme for vim");
if not File.directory?("#{VIM_FOLDER}/bundle/vim-colors-solarized") then
	system "cd #{VIM_FOLDER}/bundle && git clone " + SOLARIZED_VIM_URL;
else
	puts "Already downloaded."
end

printSubHeader("Set .vimrc");
if File.read("#{HOME_FOLDER}/.vimrc").include?("set background=dark") then
	puts "vimrc already configured";
else
	system "echo 'set background=dark\ncolorscheme solarized' >> #{HOME_FOLDER}/.vimrc";
	puts "vimrc modified";
end




printHeader("STEP SOMETHING :: Download Spectacle");
if not File.directory?("#{DOWNLOADS_FOLDER}/Spectacle.app") then
	system "curl #{SPECTACLE_URL} > #{DOWNLOADS_FOLDER}/Spectacle.zip";
	system "unzip -q #{DOWNLOADS_FOLDER}/Spectacle.zip";	
	# still need to open it here?
	# To set preferences to startup at login
	system "open #{DOWNLOADS_FOLDER}/Spectacle.app";
else
	puts "Spectacle already downloaded.";
end


# Homebrew
# Vim - pathogen with solarized, correct vimrc, notes syntax, and something else, plugins, paredit, rainbow parens, clojure-plugin-static (or something)
# Solarized for Terminal
# Set up aliases (configurable options?  Don't need clockin/out script on a work computer, eg)
# zsh and oh-my-zsh (Do I have configurations for this?)
# antigen and zshrc (aliases)
# Spectacle
# Clean-up script?
# Decide on nomenclature (download, set up, configure, etc.)
# print commands as you run them maybe?
# functions for test-cloning and test-appending

END {
	puts "\n";	
	puts "Environment setup (hopefully) completed!";
}
