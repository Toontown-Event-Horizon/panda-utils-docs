Asset Composer
==============

Since the version 1.5, Panda Utils includes an automation tool on top of Asset Pipeline
that can be used to rebuild changed models on demand with low configuration requirements.
This tool has functionality similar to Makefiles, however it is more flexible and has better crossplatform support.

Preliminaries
-------------

* Panda Utils must be installed with composer support:

.. code-block:: console

   (.venv) $ pip install panda-utils[composer]

* The preliminaries for Asset Pipeline itself also must be fulfilled.
  Note that installing composer dependency automatically installs the pipeline dependency as well.
* The same directory structure described in :doc:`./introduction` is used by Composer.

Basic functionality
-------------------

Composer is configured through a YAML file ``targets.yml`` located in the project root:

.. code-block::

   input/
   ├─ asset-folder/
   │  ├─ other-folder/
   │  │  ├─ model.blend
   │  │  ├─ texture.png
   │  │  ├─ texture2.png
   ├─ ...
   common/
   ├─ ...
   intermediate/
   ├─ ...
   built/
   ├─ ...
   scripts/
   ├─ ...
   bscripts/
   ├─ ...
   targets.yml

Composer will find assets in the ``input`` folder. By default, each folder without any subfolders
will be considered one asset, and Composer will run the asset pipeline once for that folder.
If this is undesired (i.e. you want to keep textures in a subfolder) you can put ``model-config.yml`` file
in the parent folder for the entire asset:

.. code-block::

   input/
   ├─ asset-folder/
   │  ├─ other-folder/
   │  │  ├─ model.blend
   │  │  ├─ model-config.yml
   │  |  ├─ textures/
   │  │  |  ├─ texture2.png

In this configuration, ``other-folder`` is considered one asset, despite having a subfolder.
The ``model-config.yml`` can be empty, but often will be used for the pipeline configuration.

Unlike Asset Pipeline, Composer enforces the structure of the ``input/`` folder.
When configured, Composer can be launched through ``python -m panda_utils.assetpipeline.composer``
in the folder with ``targets.yml`` or any of its subfolders.
This script accepts the same parameters `PyDoit <https://pydoit.org/cmd-run.html>`_ does.

Configuration example
---------------------

The example below describes all configuration parameters that can be used by composer.

.. code-block:: yaml

   common:
     # This block includes paths to all Common Texture Sets used in the pipeline.
     # Optional, default empty.
     cts_name: phase_1/maps/copy-here
     cts_name2: phase_1/maps/copy-here2
   settings:
     # This block includes the default settings, some can be also overridden on folder level.
     # The defaults are described below.
     default_import_method: gltf2bam  # "gltf2bam", "blend2bam", "yabee"
     collision_system: builtin        # "builtin", "bullet". does not affect collide[], only collisions set through blender
     srgb_textures: false             # true or false
     legacy_materials: false          # true or false
   targets:
     # This block is indexed by the folder names in input/.
     # Composer expects that each folder is related together and has similar building mechanisms,
     # although overrides can be made and are often needed they're quite verbose.
     asset-folder:
       # All instructions below assume the phase structure, but it is not required for composer's functionality
       active: true                    # if false this folder will not be built
       import_method: gltf2bam         # overrides the import method sets in settings if a different one is needed
       model_path: phase_1/models/gui  # required.
       texture_path: phase_1/maps      # required.
       callback_type: standard         # "2d-palette", "standard", "actor"
       parameters: {}                  # see below
       extra_steps: {}                 # see below
       overrides: {}                   # see below
     # Note that it is considered an error if a folder is present but a target is not
     # Make a target with active: false if certain folder should not be built
     asset-folder2: ...

The currently possible callback types include:

* ``2d-palette``, which will build a 2D palette out of a set of 2D textures (i.e. icons).
  The steps included by default: ``downscale(disabled), texture_cards, palettize(1024), egg2bam``
* ``standard``, which will build a 3D model, and all build tools (YABEE, blend2bam, gltf2bam) are supported.
* ``actor``, which is mostly the same as ``standard``, except it enforces the use of YABEE
  (as we found it works better than gltf2bam for certain actors) and inserts an ``optchar`` step.
  If this is not desired, you can use ``standard`` and add optchar manually.

Parameters
----------

The default parameter values can be overridden either on a model level, or on a folder level.
The model-level overrides are covered in the Overrides section below.

The parameters override is a dictionary mapped by the command name, for example:

.. code-block:: yaml

   parameters:
     downscale: '1024'
     palettize: '1024:ordered'
     yabee: {}
     collide: []
     cts:
       - 'cts_name'
       - 'cts_name2'
     preexport: false

The following parameter types can be used:

* Any string parameter will be used verbatim. If multiple values need to be set, they can be separated by colons.
* Any dict parameter will be added as ``{}``
* Any empty list parameter will be added as ``[]``
* Any non-empty list parameter will be added multiple times, with each list item used as a separate step
* Setting parameters to false will remove the step from the pipeline for that model/folder

The following steps can be configured this way:

* ``downscale``
* ``cts``
* ``texture_cards``
* ``palettize``
* ``optimize``
* ``egg2bam``
* ``optchar``

Extra Steps
-----------

Extra steps can be added either on a model level, or on a folder level.
The model-level extra steps are covered in the Overrides section below.

The extra steps is a dictionary mapped by the command name. More complex than parameters. For example:

.. code-block:: yaml

   extra_steps:
     script:
       parameters: 'myCoolScript'
       before: egg2bam
     transparent:
       after: palettize[]

Each step needs at least ``after`` or ``before`` and will match either on command name or on full command string.
These are self-explanatory. The parameters are configured in the same way as the Parameters overrides work.

If multiple copies of the same step (with different parameters) are needed, a list can be provided instead:

.. code-block:: yaml

   extra_steps:
     script:
       - parameters: 'myCoolScript'
         before: egg2bam
       - parameters: 'anotherScript'
         before: egg2bam

The following parameters will be also automatically picked up if they're in model-config.yml,
regardless of whether the extra steps are present:

* ``collide``
* ``transform``
* ``group_rename``
* ``group_remove``
* ``uvscroll``

Overrides
---------

Overrides can include extra steps or parameters.
Note that they fully override all parameter and extra step overrides on the folder level.
So if you want to reuse the extra steps while adding more, you will have to copy the initial ones too.
``callback_type``, ``import_method`` and ``active`` can also be overridden here.

.. code-block:: yaml

   overrides:
     some-model:
       import_method: yabee
       parameters:
         downscale: '1024'
       extra_steps:
         script:
           - parameters: 'script1'
             before: egg2bam
           - parameters: 'script2'
             before: egg2bam
     other-model:
       active: false
     some-palette:
       callback_type: 2d-palette

Production Steps
----------------

Certain steps like image compression might not be needed for local development and long/hard to do,
while being important for production builds.
In the same way, steps like making all collisions visible can be useful for local development,
but not at all useful for production.
Composer allows marking extra steps as being marked for production or for development,
which can be controlled with ``PANDA_UTILS_PRODUCTION`` environmental variable.
Setting this variable to any non-empty value will enable all production steps and disable all development steps.

By default, most steps (including all steps in presets) will run regardless of this variable.

.. code-block:: yaml

   overrides:
     some-model:
       extra_steps:
         script:
           - parameters: 'compressAllImages'
             before: egg2bam
             production: true
           - parameters: 'showAllCollisions'
             before: egg2bam
             production: false
