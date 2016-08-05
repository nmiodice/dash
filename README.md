#dash -- bookmarks for your terminal
Dash is a simple to use tool that allows you to bookmark certain directories that you use in your terminal. We call these bookmarks a `dash`.

When you save a `dash`, the script will automatically save the followign environment variables: `PWD`. You can override which variables are saved, making it simple to customize your `dash` environments even further! 



##Examples, features & usage
Dash is easy to use. After installing, you can try the following:


- Display help:

```
$ dash
usage: 
    dash [-h help | -ls list | -l load | -s save | -rm delete] [name]
```

- Save a `dash`

```
$ cd ~/dev/projects
$ dash -s projects
```

- View saved `dashes`

```
$ dash -ls
desk       | Desktop/
dev        | dev/
home       | myuser/
media      | mediaserver/
projects   | projects/
research   | client/
```

- Load a `dash`

```
$ cd ~
$ dash -l projects
'projects' dash loaded.
$ pwd
/Users/myuser/dev/projects
```
Note, `dash <name>` is shorthand for `dash -l <name>`

- Load a `dash` and move deeper into the directory

```
$ cd ~
$ dash -l projects/mediaserver/client
'projects' dash loaded. Moved to 'mediaserver/client'
$ pwd
/Users/myuser/dev/projects/mediaserver/client
```

- To change which environment variables are saved you will need to modify `~/.dash/.profile`. This file is auto-generated the first time you run the script, and every line in this file corresponds to one env variable that will be saved for each new `dash`. Just list which variables you'd like to save, and each `dash` you save in the future will save only those variables. 

##Dependencies
Dash is a `bash` script, so you need to have the `bash` shell installed in order to use it.

## Installation
1. Find a home for `dash.sh`
2. Add the following to your `.bashrc` or `.bash_profile` file: `alias dash="source <location from step 1>/dash.sh"`
3. Either open a new `bash` shell, or if you already have a `bash` shell open, run `source ~/.bashrc` or `source ~/.bash_profile`
