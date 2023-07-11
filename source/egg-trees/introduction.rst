Egg Trees
=========

Panda Utils includes a number of utilities to work with Egg Syntax Trees. This allows for easy parsing
and modification of Egg files.

The code for these utilities is in the ``panda_utils.eggtree`` module. There is no full API documentation
available at the time.

This does not serve as a tutorial to Egg syntax, refer to Panda3D documentation for that.

Loading and saving
------------------

The egg file can be loaded by running ``eggparse.egg_tokenize`` function. It accepts a list of lines.
The resulting ``EggTree`` object can be stringified and saved back into the file after the work:

.. code-block:: python

   from panda_utils.eggtree import eggparse

   with open("file.egg") as f:
       eggtree = eggparse.egg_tokenize(f.readlines())

   # do your operations...

   with open("file.egg", "w") as f:
       f.write(str(eggtree))

Node search and deletion
------------------------

The tree allows searching for nodes based on their type. Any subtree of the tree also allows
searching for nodes inside that tree. For example, the following code removes all lines from the file:

.. code-block:: python

   from panda_utils.eggtree import eggparse

   with open("file.egg") as f:
       eggtree = eggparse.egg_tokenize(f.readlines())

   lines = eggtree.findall("Line")
   eggtree.remove_nodes(set(lines))

   with open("file.egg", "w") as f:
       f.write(str(eggtree))

.. note:: Any collection can be passed into ``remove_nodes``, but it is recommended to use sets
   as that provides a huge performance boost (each node in the tree will be tested against being
   in that collection).

You also can find and remove nodes in a child node:

.. code-block:: python

   from panda_utils.eggtree import eggparse

   with open("file.egg") as f:
       eggtree = eggparse.egg_tokenize(f.readlines())

   group = next(eggtree.findall("Group"), None)
   if group:
      polys = group.findall("Polygon")
      even_polys = polys[::2]
      group.remove_nodes(set(even_polys))

   with open("file.egg", "w") as f:
       f.write(str(eggtree))

.. note:: for recursive nodes, ``findall`` returns instances of ``EggBranch`` instead of ``EggTree``. Subtle
   difference, explained below.

.. warning:: ``findall`` returns a list of nodes, not a generator. If you're loading huge files
   (~1M and more polygons) and search for something like ``Vertex`` or ``Polygon`` which there are
   millions in the file it will cause performance and memory spikes. We've successfully tested eggparse
   on 40K polygon models though, and from our tests anything in low-poly games will not have performance issues
   as long as you're not repeatedly loading and saving the model.

Node classes
-------------

There are three types of nodes supported by Panda Utils - ``EggString``, ``EggLeaf``, and ``EggBranch``.

* ``EggString`` is an internal node including one string of text inside of it. It can never be inside a tree,
  except when that tree is a part of a branch. See ``<Matrix3>`` below for an example.
* ``EggLeaf`` is a node that does not have other nodes inside of it. Most Panda3D nodes are of this type.
  For example, ``<Scalar>``, ``<UV>``, ``<Collide>``, etc.

.. code-block::

   <Scalar> alpha { dual }
   <TRef> { TextureFile }

These two nodes will be transformed into:

.. code-block:: python

   alpha_dual = EggLeaf("Scalar", "alpha", "dual")
   tref = EggLeaf("TRef", None, "TextureFile")
   # alpha_dual.node_type == "Scalar"
   # alpha_dual.node_name == "alpha"
   # alpha_dual.node_value == "dual"

* ``EggBranch`` is a node that includes other nodes. It actually stores an ``EggTree`` as its value, the same type
  that is returned when ``egg_tokenize`` is invoked.

.. code-block::

   <Polygon> {
     <TRef> { TextureFile }
     <MRef> { MaterialName }
     <BFace> { 1 }
     <VertexRef> { 1 2 3 <Ref> { Scene } }
   }

This node will be transformed into:

.. code-block:: python

   tref = EggLeaf("TRef", None, "TextureFile")
   mref = EggLeaf("MRef", None, "MaterialName")
   bface = EggLeaf("BFace", None, "1")
   vref = EggLeaf("VertexRef", None, "1 2 3 <Ref> { Scene }")
   polygon_tree = EggTree(tref, mref, bface, vref)
   polygon = EggBranch("Polygon", None, polygon_tree)
   # polygon.node_type == "Polygon"
   # polygon.node_name empty here, but can be non-empty in other scenarios
   # polygon.children == polygon_tree

Something like a ``<Matrix3>`` would get transformed into an ``EggBranch`` containing ``EggStrings``,
same with ``<Comment>`` (not shown here):

.. code-block::

   <Matrix3> {
     1 0 0
     0 1 0
     0 0 1
   }

This node will be transformed into:

.. code-block:: python

   top_row = EggString("1 0 0")
   mid_row = EggString("0 1 0")
   bot_row = EggString("0 0 1")
   matrix_tree = EggTree(top_row, mid_row, bot_row)
   matrix = EggBranch("Matrix3", None, matrix_tree)

Adding nodes
------------

After creating a node like done above, it can be inserted into any eggtree
through ``EggBranch.add_child`` or ``EggTree.children.insert`` (depending on what node is found):

.. code-block:: python

   from panda_utils.eggtree import eggparse

   with open("file.egg") as f:
       eggtree = eggparse.egg_tokenize(f.readlines())

   tex = next(eggtree.findall("Texture"), None)
   if tex:
      alpha = eggparse.EggLeaf("Scalar", "alpha", "dual")
      tex.add_child(alpha)

   with open("file.egg", "w") as f:
       f.write(str(eggtree))
