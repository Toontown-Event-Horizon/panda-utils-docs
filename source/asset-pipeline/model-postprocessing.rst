Model Postprocessing
====================

Group rename
------------

This step renames all collections with the given name into a different name.

Arguments
~~~~~~~~~

This step uses keyword arguments, which means it can only be run through model configuration.
Setting a name to ``__delete__`` will delete the node. For example:

.. code-block:: yaml

   group_rename:
     hands.003: hands
     useless-node: __delete__

Examples
~~~~~~~~

* ``group_rename[]``

Group remove
------------

This step removes all collections with the given name. Unlike group rename, allows using fnmatch syntax to find the collections.

Arguments
~~~~~~~~~

Accepts one argument equal to the fnmatch pattern that is removed. Can be run multiple times if desired.

.. code-block:: yaml

   group_remove:
     - coll*
     - *useless*
     - group_name

Examples
~~~~~~~~

* ``group_remove[]``
* ``group_remove:*useless*``

Transform
---------

This step will apply the given transforms to every egg file it encounters.
Each transform is a combination of ``scale``, ``rotate``, and ``translate``.

Arguments
~~~~~~~~~

This step accepts three arguments ``scale``, ``rotate``, and ``translate``.
For example: something like ``transform:10:0,0,180:0,-0.25,1``
will first increase the model scale 10 times, then rotate it 180 degrees around the Z axis
(functionally setting its H angle to 180),
and then translate it 1 unit upwards and 0.25 units backwards.

It is recommended to use model configuration to load the arguments for this step. For example:

.. code-block:: yaml

   translate:
     - scale: 10
     - rotate: 0,100,0

Examples
~~~~~~~~

* ``transform[]``
* ``transform:10:0,0,180:0,-0.25,1``

Collide
-------

This step will automatically add collision geometry to a model.
This step will not automatically make decimated collision geometry, that has to be done separately if desired.
It can either add preset geometry types like Sphere, or Polyset geometry for complex shapes.
Note that adding Polyset collisions is computationally expensive for the players of the game
and having a decimated model for polysets is recommended.
Not compatible with games using Bullet.

Arguments
~~~~~~~~~

This step takes up to four arguments:

* ``flags``: comma-separated list of Egg collision flags. Defaults to ``keep,descend``.
* ``method``: lowercase type of the collider (``sphere``, ``polyset``, etc.)
  Defaults to ``sphere``, which is undesired in most cases.
* ``group_name``: If supplied, the collision will be added to a node with the given name.
  If not supplied (default), the collision will be added to a node with the name = input_folder's name
  (this group is automatically created by the model_parent step or can be made manually).
* ``bitmask``: If supplied, uses a non-standard collide bitmask.

This step can appear multiple times in the pipeline if one wants to add multiple collision solids
to different parts of the model. Due to the complexity of the arguments,
it is recommended to use model confiiguration for this step.

.. code-block:: yaml

   collide:
     - group_name: cube.010
       method: polyset
       flags: keep,descend
     - group_name: coll_only_solid
       method: polyset
       flags: descend

Examples
~~~~~~~~

* ``collide[]``
* ``collide:descend:polyset:optimized_geom``
* ``collide:keep,descend:tube``
* ``collide``

Remove materials
----------------

This step removes all materials and UV maps from the models.
This is needed to export certain actors, and things like toon heads.
You should not use this step unless you know what you're doing.

Note that applying this step before ``palettize`` will not have any effect.
It has to either be after ``palettize``, or not having ``palettize`` in pipeline at all.

Arguments
~~~~~~~~~

This step takes no arguments.

Examples
~~~~~~~~

* ``rmmat``

Transparency
------------

This step makes all textures in the model semitransparent
by adding ``<Scalar> alpha { dual }`` to all of them.
You should not use this unless you get transparency-related rendering issues.

Note that applying this step before ``palettize`` will not have any effect, similarly to ``rmmat``.

Arguments
~~~~~~~~~

This step takes no arguments.

Examples
~~~~~~~~

* ``transparent``

Delete Vertex Colors
--------------------

This step removes vertex colors from all vertices in the model.
This can be used when the vertex colors are exported incorrectly from Blender.
A common case is the model being invisible, but having wireframe while loaded in PView
(wireframe can be toggled by pressing ``w``).

Arguments
~~~~~~~~~

This step takes no arguments.

Examples
~~~~~~~~

* ``delete_vertex_colors``
