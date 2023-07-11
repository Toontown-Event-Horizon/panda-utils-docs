Scripting
=========

Script step
-----------

Panda Utils allows inserting arbitrary steps at any point of Asset Pipeline.
These steps have to be written using Python scripts.
The script must have a single function ``run`` which takes one parameter ``ctx``, for example:

.. code-block:: python

   def run(ctx):
       ctx.cache_eggs()
       for tree in ctx.eggs.values():
           nodes_for_removal = (
               tree.findall("Material")
               + tree.findall("MRef")
               + tree.findall("Normal")
               + [scalar for scalar in tree.findall("Scalar") if scalar.node_name == "uv-name"]
           )
           tree.remove_nodes(set(nodes_for_removal))

           uvs = tree.findall("UV")
           for uv in uvs:
               uv.node_name = None
           darts = tree.findall("Dart")
           for dart in darts:
               dart.node_value = "1"

The ``ctx`` is an instance of Pipeline Context.
It has a number of attributes, but the following are the most useful:

* ``model_name`` - the name of the model being worked on.
* ``eggs`` - a dictionary. See ``cache_eggs`` below.
* ``files`` - all files in the current directory, in sorted order.
  Note that this will update in real time as you add or remove files, so be careful.
* ``cache_eggs()`` - loads all egg files in folder into `eggs` dictionary,
  which will have the filenames as keys and the syntax trees as values (see :doc:`../egg-trees/introduction`).
  This is useful if the script does operations on the syntax tree.
* ``uncache_eggs()`` - saves all egg syntax trees back into the files.
  This is useful if the script operates on egg files directly (``egg-trans``, ``egg-optchar`` etc.)
* ``putil_ctx`` - a context that can be used to call the Utils-Core functions (i.e. ``run_panda``).

Generally you don't need to run ``uncache_eggs`` at the end of working with trees,
or run ``cache_eggs`` at the end of not working with trees, the other steps
have a convention to run this only at the start.

Arguments
~~~~~~~~~

This step includes one parameter.

* ``script_file`` - the name of a file to run, required. It is expected to be located
  in ``scripts/{script_file}.py``

Examples
~~~~~~~~

* ``script:magic1``
