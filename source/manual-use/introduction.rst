Manual Use
==========

Panda Utils includes a number of various scripts used for manual model processing. Most of them operate
on Egg files (a text-based format used by Panda3D).

We recommend running these scripts in "Workspace", which is a directory outside of the game folder.
It is determined by the cwd. You can run the scripts in the game assets folder, but this is discouraged
as it leaves behind various temporary intermediate files.

Running Panda Utils in manual mode requires installing the ``runnable`` dependency:

.. code-block:: console

   (.venv) $ pip install panda-utils[runnable]

You may optionally install ``autopath`` dependency to inherit the Panda3D path (recommended if you use stock
Panda3D), and/or ``imagery`` to use the downscale script.

It also requires making a configuration file. Running any manual command will fail if the file is not present.
The location of this file is different per operating system, and suggested by the script when it fails in such a way.
The contents of the file should look somewhat like this:

.. code-block:: ini

   [paths]
   resources = /path/to/your/game/resources
   panda = /path/to/your/venv/bin

If Panda3D is installed in the same venv, the panda path can also be derived from that virtualenv
with the following config file:

.. code-block:: ini

   [paths]
   resources = /path/to/your/game/resources
   [options]
   panda3d_path_inherit = 1
