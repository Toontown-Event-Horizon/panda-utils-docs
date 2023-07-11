Miscellanous Helpers
====================

Copy
----

This script copies assets from the current working folder into the game resources folder, or vice versa.
It preserves any relative paths in the folder. For example, if your structure looks like this:

.. code-block::

   game/
   ├─ resources/
   │  ├─ ingame-file.bam
   workspace/
   ├─ outgame-file.bam
   ├─ outgame-folder
   │  ├─ another-file.bam

You can run either of these commands while being in the ``workspace`` folder:

.. code-block:: console

   (.venv) $ python -m panda_utils copy -r ingame-file.bam
   (.venv) $ python -m panda_utils copy outgame-file.bam
   (.venv) $ python -m panda_utils copy outgame-folder
   (.venv) $ python -m panda_utils copy outgame-folder/another-file.bam

Running with ``-r`` copies files from game folder to workspace folder, otherwise files are copied from workspace
into the game folder.

Run from file
-------------

This script runs another script written in a file. It is primarily recommended for use with Animation Rename,
which can have very long argument lists. For example, if the file's contents are the following:

.. code-block::

   animrename input_folder output_folder old-joint=NewJoint,old-joint2=NewJoint2

Then the following command:

.. code-block:: console

   (.venv) $ python -m panda_utils fromfile command.txt

is equivalent to the following command:

.. code-block:: console

   (.venv) $ python -m panda_utils animrename input_folder output_folder old-joint=NewJoint,old-joint2=NewJoint2
