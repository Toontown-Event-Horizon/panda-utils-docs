Common Operations
=================

Certain common operations are accessible programmatically.
Those are in the ``panda_utils.eggtree.operations`` module.
All of the operations act on a tree by reference, and do not return anything.

Creating a comment
------------------

Under the hood, comments are an ``EggBranch`` with a single ``EggString`` inside of it.

.. code-block:: python

   from panda_utils.eggtree import eggparse, operations

   with open("file.egg") as f:
       eggtree = eggparse.egg_tokenize(f.readlines())

   operations.add_comment(eggtree, "Made with Panda Utils")
   with open("file.egg", "w") as f:
       f.write(str(eggtree))

Setting the texture prefix
--------------------------

This is a quite complex operation. It is used to fix the texture paths, often used when a path is absolute
or relative to a wrong folder. For example, the following ``<Texture>`` node:

.. code-block::

   <Texture> TextureName {
     /c/users/careless-developer/image.png
     ...
   }

can be easily transformed into the following node:

.. code-block::

   <Texture> TextureName {
     phase_1/maps/image.png
     ...
   }

This path can include the ``..`` symbol if needed, it also does not check the validity of the path at all,
so be careful. All textures will be updated at the same time, even those that point to a different folder.
So if your model is supposed to have textures at both ``phase_1/maps/image.png``
and ``phase_2/maps/map-folder/image2.png`` you are out of luck.
However, if your model has textures at ``phase_1/maps/image.png`` and ``phase_1/maps/subfolder/image2.png``
you can use this step to set the texture prefix to ``phase_1/maps``.
In order for that to work, the second texture path needs to be already set to the correct path
(can be done through manual <Texture> manipulation).
In general, any path that already starts with the texture prefix and does not have ``..`` in it will not be changed.

.. code-block:: python

   from panda_utils.eggtree import eggparse, operations

   with open("file.egg") as f:
       eggtree = eggparse.egg_tokenize(f.readlines())

   operations.set_texture_prefix(eggtree, "phase_1/maps")
   with open("file.egg", "w") as f:
       f.write(str(eggtree))
