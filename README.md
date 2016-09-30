# Singularity Environments

These are base software environments for labs to use on research clusters. The general workflow is as follows:


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

First, you should use the provided build script to generate an executable for your environment:

      ./build.sh python3.def

This will generate a python3 executable in the present working directory. If you want to change the size of the container, or add any custom arguments to the <a href="https://singularityware.github.io/docs-bootstrap" target="_blank">Singularity bootstrap</a> command, you can add them after your image name:

      ./build.sh python3.def --size 786

Note that the maximum size, if not specified, is 1024*1024BMiB.

## Step 2. Transfer the contained environment to your cluster

You are likely familiar with FTP, or hopefully your cluster uses a secure file transfer (sFTP). You can also use a command line tool [scp](https://www.garron.me/en/articles/scp.html). For the Sherlock cluster at Stanford, since I use Linux (Ubuntu), my preference is for [gftp](http://www.howtogeek.com/howto/ubuntu/install-and-use-the-gftp-client-on-ubuntu-linux/).

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


TODO:

https://hub.docker.com/_/mongo/
https://hub.docker.com/_/mysql/
https://hub.docker.com/_/postgres/
https://hub.docker.com/_/node/
https://hub.docker.com/_/rails/
https://hub.docker.com/_/perl/
https://hub.docker.com/_/mariadb/
https://hub.docker.com/_/django/
https://hub.docker.com/_/openjdk/
https://hub.docker.com/_/r-base/
https://hub.docker.com/_/julia/
https://hub.docker.com/_/clojure/
