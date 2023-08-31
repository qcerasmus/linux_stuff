# Random scripts and configs that I use

## Configs folder

### .clang-format
Used in combonation with the setup_cmake_project.sh file. Used to format my c++ project how I like them.

### .tmux.conf
When using vim with tmux there is a delay when hitting escape.
To go to the next window or tab it doesn't use hjkl for navigation by default so that is fixed as well.

## Scripts folder
### vim_setup.sh
Will take the vimrc file in the vim folder and copy it to the home directory.
After running the script, run ":PlugInstall" in normal mode to install all the plugins.
This includes:

- NerdTree = Nice File Explorer
- onedark theme = My favorite theme I've found
- vim polyglot = syntax highlighting for many languages
- lightline = very nice status bar
- vim-buftabline = adds a buffer line to the top
- vim-lsp = lsp integration
- vim-lsp-settings = 
- asyncomplete = auto complete
- asyncomplete-lsp = auto complete with lsp integration

### vim keybinds
- leader = ,
- mm = escape
- U = redo
- F2 = Nerd tree toggle
- control+hjkl = move between windows
- gn = buffer next
- gp = buffer previous
- bc = buffer delete

LSP
- gd = go to definition
- gs = document symbol search
- gS = workspace symbol search
- gr = search references
- gi = go to implementation
- gt = type definition
- <leader>rn = rename
- [g = previous diagnostic
- ]g = next diagnostic
- K = lsp hover
- gN = next error
- gP = previous error
- ga = code action
- gk = format document

### make_cmake_project.sh
Run it with an argument for the project name.
It will make a new folder and initialize a barebones project for cmake.
It will copy the file .clang-format to the directory as well.

