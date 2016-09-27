# Customizing Singularity Environments

The definition files can be modified before you create the environments! First, let's talk a little about Singularity.

## What is Singularity?
We will be using <a href="https://singularityware.github.io">Singularity</a> containers that don't require root priviledges to run on the cluster for our environments. Further, we are going to "bootstrap" Docker images so we don't have to start from nothing! You can think of this like packaging an entire software suite (for example, python) into a container that you can then run as an executable:

      $ ./python3 
      Python 3.5.2 (default, Aug 31 2016, 03:01:41) 
      [GCC 4.9.2] on linux
      Type "help", "copyright", "credits" or "license" for more information.
      >>> 

Even the environment gets carried through! Try this:

      import os
      os.environ["HOME"]

### A little about the definition file
Okay, so this folder is filled with *.def files, and they are used to create these "executable environments." What gives? Let's take a look quickly at a definition file:

      Bootstrap: docker
      From: python:3.5

      %runscript
      
          /usr/local/bin/python


      %post

          apt-get update
          apt-get install -y vim
          mkdir -p /scratch
          mkdir -p /local-scratch

The first two lines might look (sort of) familiar, because "From" is a Dockerfile spec. Let's talk about each:

- Bootstrap: is telling Singularity what kind of Build it wants to use. You could actually put some other kind of operating system here, and then you would need to provide a Mirror URL to download it. The "docker" argument tells Singularity we want to use the guts of a particular Docker image. Which one?
- From: is the argument that tells Singularity bootstrap "from this image." 
- runscript: is the one (or more) commands that are run when someone uses the container as an executable. In this case, since we want to use the python 3.5 that is installed in the Docker container, we have the executable call that path.
- post: is a bunch of commands that you want run once ("post" bootstrap), and thus this is where we do things like install additional software or packages.

### Making changes
It follows logically that if you want to install additional software, do it in post! For example, you could add a `pip install [something]`, and since the container is already bootstrapped from the Docker image, pip should be on the path. For example, here is how I would look around the container via python:

      ./python3 
      Python 3.5.2 (default, Aug 31 2016, 03:01:41) 
      [GCC 4.9.2] on linux
      Type "help", "copyright", "credits" or "license" for more information.
      >>> import os
      >>> os.system('pip --version')
      pip 8.1.2 from /usr/local/lib/python3.5/site-packages (python 3.5)
      0
      >>> 
 
or using the Singularity shell command to bypass the runscript (/usr/local/bin/python) and just poke around the guts of the container:

      $ singularity shell python3
      Singularity: Invoking an interactive shell within container...

      Singularity.python3> which pip
      /usr/local/bin/pip

If you would like any additional docs on how to do things, please post an issue. I'm still in the process of thinking about how to best build and leverage these environments.

