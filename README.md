# Singularity Environments

These are base software environments for labs to use on research clusters using <a href="https://www.github.com/gmkurtzer/singularityware" target="_blank">Singularity</a>. Note: you must download the version of Singularity (2.2) from the master branch to get this full functionality, as 2.2 has not been officially released yet. The general workflow is as follows:


 1. On your local machine (or an environment with sudo) build the contained environment
 2. Transfer the contained environment to your cluster
 3. Add the executable to your path, or create an alias.


We will first be reviewing the basic steps for building and deploying the environments. 

## Step 0. Setup and customize one or more environments
You will first want to clone the repository, or if you want to modify and save your definitions, fork and then clone the fork first. Here is the basic clone:

      git clone https://www.github.com/radinformatics/singularity-environments
      cd singularity-environments

You can then move right into building one or more containers, or optionally [customize environments first](CUSTOM.md).


## Step 1. Build the Contained Environment

First, you should use the provided build script to generate an executable for your environment. For now, this means copying the build script into the folder you want (eg, `python/python3`) and then do:

      ./build.sh python3.def

This will generate a python3 executable in that directory. If you want to change the size of the container, or add any custom arguments to the <a href="https://singularityware.github.io/docs-bootstrap" target="_blank">Singularity bootstrap</a> command, you can add them after your image name:

      ./build.sh python3.def --size 786

Note that the maximum size, if not specified, is 1024*1024BMiB.

## Step 2. Transfer the contained environment to your cluster

You are likely familiar with FTP, or hopefully your cluster uses a secure file transfer (sFTP). You can also use a command line tool [scp](https://www.garron.me/en/articles/scp.html). For the Sherlock cluster at Stanford, since I use Linux (Ubuntu), my preference is for [gftp](http://www.howtogeek.com/howto/ubuntu/install-and-use-the-gftp-client-on-ubuntu-linux/).

### Likely to change
The definition files are (likely) going to take on a common name, `Singularity` akin to a `Dockerfile` and we will have one per folder. For now we will maintain these names and build script.

## Step 3. Add the executable to your path

Let's say we are working with a python3 image, and we want this executable to be called before the python3 that is installed on our cluster. We need to either add this python3 to our path (BEFORE the old one) or create an alias. 

### Add to your path
You likely want to add this to your `.bash_profile`, `.profile`, or `.bashrc`:

      mkdir $HOME/env
      cd $HOME/env
      # (and you would transfer or move your python3 here)

Now add to your bashrc:

      echo "PATH=$HOME/env:$PATH; export PATH;" >> $HOME/.bashrc
      

### Create an alias
This will vary for different kinds of shells, but for bash you can typically do:

      alias aliasname='commands'

      # Here is for our python3 image
      alias python3='/home/vsochat/env/python3'

For both of the above, you should test to make sure you are getting the right one when you type `python3`:

      which python3
      /home/vsochat/env/python3


The definition files in this base directory are for base (not hugey modified) environments. For examples of custom environments (those to be used by Langlotz lab) look in [custom](custom)


## Modifying Environments
Let's say you have an environment (node6, for example), and you want to install a package with npm (which is localed at /usr/local/bin/npm), but then when you run the image:

      ./node6

it takes you right into the node terminal. What gives? How do you do it? You use the Singularity shell, with write mode. We can first look at the help docs for it:


      singularity --help shell
      USAGE: singularity [...] shell [shell options...] <container path>

      Obtain a shell (/bin/sh) within the container image.

      note: When invoking a shell within a container, the container image is
      by default writable.


      SHELL OPTIONS:
          -B/--bind <spec>    A user-bind path specification.  spec can either be a
                              path or a src:dest pair, specifying the bind mount to
                              perform (can be called multiple times)
          -c/--contain        This option disables the automatic sharing of writable
                              filesystems on your host (e.g. $HOME and /tmp).
          -C/--containall     Contain not only fle systems, but also PID and IPC
          -H/--home <path>    Path to a different home directory to virtualize within
                              the container
          -i/--ipc            Run container in a new IPC namespace
          -p/--pid            Run container in a new PID namespace (creates child)
          --pwd               Initial working directory for payload process inside
                              the container
          -S/--scratch <path> Include a scratch directory within the container that
                              is linked to a temporary dir (use -W to force location)
          -s/--shell <shell>  Path to program to use for interactive shell
          -u/--user           Try to run completely unprivileged (only works on very
                              new kernels/distros)
          -W/--workdir        Working directory to be used for /tmp, /var/tmp and
                              $HOME (if -c/--contain was also used)
          -w/--writable       By default all Singularity containers are available as
                              read only. This option makes the file system accessible
                              as read/write.

           ...


We first want to move the image back to our local machine, because we don't have sudo on our cluster. We then want to use the writable option:

      sudo singularity shell --writable node6
        Singularity: Invoking an interactive shell within container...

        Singularity.node6> 

Then we can make our changes, and move the image back onto the cluster.


### To add
https://hub.docker.com/_/julia/
https://hub.docker.com/_/clojure/
