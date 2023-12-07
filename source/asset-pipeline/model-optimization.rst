Model Optimization
==================

Optimize
--------

This step will do the following transformations to every EGG model it finds:

* Removes the default cube ``Cube.N`` and camera ``Camera`` groups from the file if they're found inside.
  It normally does not affect meshes based on a cube but ones that are not cubes.
  Unless you never rename your meshes and keep the default names, in which case please rename your meshes.
* Renames all textures to follow a consistent naming pattern.
  For example, if textures ``file1.png``, ``Randomfile.jpg`` and ``otherFile.png`` are provided,
  they will be renamed into ``input_folder.png``, ``input_folder-1.jpg`` and ``input_folder-2.png``
  (the order is not guaranteed, but it will be consistent if this step is launched on multiple machines).
  It will not rename textures made from palettes (including palettize step and egg-palettize).
  This can be disabled by not providing the ``keep_texture_names`` flag.
* Deletes UV names from all vertices and from all textures.
  If the model has UV names set, each texture is set up as its own TextureStage.
  This increases the GPU load when loading the model, and prevents features like UV scroll from working.
  After this operation is performed, all textures will be loaded in the default TextureStage.
  Note that splitting texture stages is sometimes useful, for example, to transform UV maps programmatically.
  Therefore, this behavior can be disabled by providing the ``keep_uv_names`` flag.
* Replaces transparent vertex color ``0 0 0 0`` with a fully white vertex color ``1 1 1 1``.
  For some reason, Blender has transparent as the default, even though vertex colors multiply with texture colors.
  This can be disabled by providing the ``keep_transparent_vertices`` flag.
  This should work with both YABEE-based imports as well as GLTF- and blend2bam-based imports.

(more to come)

Arguments
~~~~~~~~~

This step takes up to one argument.

* ``flags``: default empty. Either a comma-separated string or a list. The options are:
  * ``keep_texture_names``: If this is present, textures will not be renamed.
    Can be used in case the model already has a naming convention used to load external textures.
  * ``keep_uv_names``: If this is present, UV names will be kept. I don't know why you need this.
  * ``keep_transparent_vertices``: If this is present, transparent vertices will be kept. If you use mb2egg idk.

Example
~~~~~~~

* ``optimize``
* ``optimize:keep_texture_names,keep_transparent_vertices``

Optchar
-------

This step runs ``egg-optchar``, setting the exposed joints and the flagged nodes.
Note that changing the dart type is currently not supported.

Arguments
~~~~~~~~~

This step takes up to three parameters.
Each of them can be comma-separated strings, or lists of strings (only if model configuration is used).

* ``flags``: the list of all flagged nodes. Default empty.
* ``expose``: the list of all exposed joints. Default empty.
* ``zero``: the list of nullified joints. Default empty.

These parameters are documented in :doc:`../panda3d-help/optchar`.

Example
~~~~~~~

* ``optchar[]``
* ``optchar:flagged-node:flagged-joint``

Palettize
---------

This step is used to join multiple texture files on a model into one palette.
It will palettize every EGG model in the folder.

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
