#!/usr/bin/env python3

import os
import sys

def exec_hook(hook):
  with open(hook) as f:
    exec(compile(f.read(), config_file, 'exec'), globals(), locals())

#def generate_hook(dotfile):

def install_hook(dotfile, dotfilesdir):
  # Fix relpath output
  if dotfile.startswith('./'):
    dotfile = os.path.basename(dotfile)

  installloc = os.path.join(os.getenv('HOME'),  '.' + dotfile)
  if not os.path.exists(installloc):
    print('Installing {} to {}'.format(dotfile, installloc))
  else:
    print('Updating {}'.format(dotfile))

  if os.path.exists(installloc):
    os.remove(installloc)

  installdir = os.path.dirname(installloc)
  if not os.path.exists(installdir):
    os.makedirs(installdir)

  os.symlink(os.path.join(dotfilesdir, dotfile), installloc)
  #print('Installing {} to {}'.format(os.path.join(dotfilesdir, dotfile), installloc))

def main():
  # TODO: Parse commandline/read config files
  dotfilesdir = sys.argv[1]

  if not os.path.exists(dotfilesdir):
   raise "Invalid directory"

  # Build ignore list
  dotfilesignorefile = os.path.join(dotfilesdir, '.kratosignore')
  if os.path.exists(dotfilesignorefile):
    with open(dotfilesignorefile) as f:
      ignore_list = f.readlines()
      ignore_list = [x.strip() for x in ignore_list]

  hookexts = (
    'install-pre',
    'install',
    'install-post',
    'generate-pre',
    'generate-post',
    'uninstall-pre',
    'uninstall',
    'uninstall-post'
  )

  # Find dotfiles
  dotfiles = [ ]
  for root, dirs, files in os.walk(dotfilesdir):
    # Exclude hidden files and directories
    dirs[:] = [d for d in dirs if not d.startswith('.')]
    files[:] = [f for f in files if not f.startswith('.')]
    # Exclude hooks
    files[:] = [f for f in files if not f.endswith(hookexts)]
    # Ignore list
    files[:] = [f for f in files if f not in ignore_list]
    for file in files:
      dotfiles.append(os.path.join(os.path.relpath(root, dotfilesdir), file))

  # Install dotfiles
  for dotfile in dotfiles:
    # PRE-Install
    if os.path.exists(dotfile + '.install-pre'):
      print(os.path.exists(dotfile + '.install-pre'))

    # Install
    if dotfile.endswith('.generate'):
      print(dotfile)
    else:
      if os.path.exists(dotfile + '.install'):
        print(os.path.exists(dotfile + '.install'))
      else:
        install_hook(dotfile, dotfilesdir)

    # POST-Install
    if os.path.exists(dotfile + '.install-post'):
      print(os.path.exists(dotfile + '.install-post'))


if __name__ == "__main__":
  main()
