Model Optimization
==================

Optimize
--------

This step will do the following transformations to every EGG model it finds:

* Removes the default cube ``Cube.N`` and camera ``Camera`` groups from the file if they're found inside.
  It normally does not affect meshes based on a cube but ones that are not cubes.
  If it did for you, file a bug report.
* Renames all textures to follow a consistent naming pattern.
  For example, if textures ``file1.png``, ``Randomfile.jpg`` and ``otherFile.png`` are provided,
  they will be renamed into ``input_folder.png``, ``input_folder-1.jpg`` and ``input_folder-2.png``
  (the order is not guaranteed, but it will be consistent if this step is launched on multiple machines).
  It will not rename textures made from palettes (including palettize step and egg-palettize).

(more to come)

Arguments
~~~~~~~~~

This step takes up to one argument.

* ``map_textures``: default true. If this is set to ``0``, ``false`` or empty string,
  textures will not be renamed, in case the model already has a naming pattern set.

Example
~~~~~~~

* ``optimize``
* ``optimize:0``

Optchar
-------

This step runs ``egg-optchar``, setting the exposed joints and the flagged nodes.
Note that changing the dart type is currently not supported.

Arguments
~~~~~~~~~

This step takes two parameters.
Both of them can be comma-separated strings, or lists of strings (only if model configuration is used).
TODO: document what these parameters do, I'm not very familiar with ``egg-optchar``.

* ``flags``: the list of all flagged nodes.
* ``expose``: the list of all exposed joints.

Example
~~~~~~~

* ``optchar[]``
* ``optchar:flagged-node:flagged-joint``

Palettize
---------

This step is used to join multiple texture files on a model into one palette.
It will palettize every EGG model in the folder.

.. warning:: There is currently a bug that using this step overwrites the textures
   which were not added to any palette. This seems to be a Panda3D issue.
   If you encounter missing textures, remove palettize from the pipeline for that model.
   It usually happens when the textures are larger than half palette width.

Arguments
~~~~~~~~~

This step takes two parameters.

* ``size`` - required, default 1024. The desired texture size. It must be a power of two.
  The default value is 1024, which means each produced palette will be 1024x1024.
* ``flags`` - optional, defaults to no flags, options are:

  * ``ordered`` - if the palettized images were named ``{number}-{name}``,
    changes the palettized node name to ``name``. Primarily used with ``texture-cards`` stage.
* ``exclusions`` - optional, list of strings (can be joined together by commas ``,``). Default empty.
  The images with the same name of an exclusion will not be added into the palette. If this argument is used,
  it is recommended to put palettize step before optimize step to not have to do guesswork for the image names.

Example
~~~~~~~

* ``palettize``
* ``palettize:2048``
* ``palettize:512:ordered``
* ``palettize:1024::ExcludeThisImage.png``
