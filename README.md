# The Teleport (tp) command!
This is an idea I wish some shell would implement. But I actually built a working prototype for the fish shell. I'm not planning on making this available for other shells anytime soon.

The idea of the command is to _"teleport"_ between saved locations in the file system. Let's say you're configuring your shell, whose config file is in some deep nested directory, like "/home/$USER/.config/fish/". After some time of tinkering with the options you are satisfied with the look and feel, you close all the instances you opened for debugging, you save and close the config file and you go on with your day. But, 30 minutes later, you realize you actually want an alias for a command you forgot to implement. Now you have to search for the path to the file again, type it and cd into it; this would be _ok_ if you had to do this, let's say, once a week or two. But since I'm always tinkering with the config files of a lot of programs myself, I usually end up doing this 8 or 10 times a day if I've just recently installed the program and it needs a lot of configuration. **The answer to this problem is the 'tp' command!**

![Create a location](demoImages/create.png)
![Go back to home](demoImages/home.png)

Of course in that example tp doesn't make a lot of sense because you can simply go back to home doing "cd" but anyway, that's the idea.

## Usage
```
-- TP command - help message --

tp -l                   => list saved locations
tp -c {name} [path]     => create a new location with {name} and {path}, if no path is given, the working directory will be used
tp -r [saved_location]  => remove the specified location or the temporary if non are given
tp -p [location]        => print location instead of changing directory
tp -h                   => outputs help message

```

With the '-c' option you create a _"location"_. _Locations_ are directories you've saved and intend to revisit frequently. For example, we can type:

```tp -c fish /home/$USER/.config/fish ```

And that would save the path _"/home/$USER/.config/fish"_ into a location named 'fish'

Then we could run ```tp fish``` and instantly cd into the directory.

You can also have a fast glance of all saved locations or remove any location you don't need anymore with the other options.

One can run tp without arguments to save the working directory. And the next time you run tp without arguments you'll be _teleported_ to the previously saved directory. Useful to point new shells to the directory you are working on without having to manually copy the PWD. This is the function that motivated the creation of this prototype!

## Instalation
### Fish
Clone this directory and **edit the fish variable "TP_DIR"** to point to the root of the repo. Then, create a symbolic link in _fish/config.d_ or source it right from _config.fish_

## Conclusions
Believe me, I would've loved to do this in c, or perhaps, python. But since the working directory is part of the shell's state we can just _change it_ from another process. So I was forced to write the program as a function in the shell's scripting language. This is the reason for the program not being available on other shells.

It was fun though! Excellent excuse to sit down and learn the fish programming language.

