Asset Pipeline
==============

Panda Utils includes a full-fledged Asset Pipeline that can be used to import Blend and/or FBX models into the game,
applying various processing stages to the model. It is also Makefile-ready, which means if attached to a Makefile,
changing a few assets only causes those assets to be rebuilt. There is currently no makefile generator
tailored to be used with the Pipeline, however :doc:`composer` can be used for the same purpose.

Preliminaries
-------------

* Panda Utils must be installed with pipeline support:

.. code-block:: console

   (.venv) $ pip install panda-utils[pipeline]

If ``downscale`` step is used, ``imagery`` dependency also has to be installed.
If ``copy`` script is used (can be convenient in some workflows), ``runnable`` dependency also has to be installed.

* The system PATH must include the Blender binary named ``blender`` or ``blender.exe``.
* The directory structure should be setup as described below.

Directory structure
-------------------

The asset pipeline expects your workspace folder to have the following directory structure:

.. code-block::

   input/
   ├─ asset-folder/
   │  ├─ other-folder/
   │  │  ├─ model.blend
   │  │  ├─ texture.png
   │  │  ├─ texture2.png
   common/
   ├─ group1/
   │  ├─ texture.png
   │  ├─ ...
   ├─ ...
   intermediate/
   built/
   ├─ phase_1/
   │  ├─ models/
   │  │  ├─ category/
   │  │  |  ├─ ...
   │  ├─ maps/
   │  │  ├─ ...
   ├─ phase_2/
   │  ├─ models/
   │  │  ├─ ...
   │  ├─ maps/
   │  │  ├─ ...
   ├─ ...
   scripts/
   ├─ magic1.py
   ├─ ...
   bscripts/
   ├─ magic2.py
   ├─ ...

Some notes about this structure:

* The model files can be Blend-files (made in Blender) or FBX-files (made in any other software).
  There is limited support for OBJ files (not recommended), and support for GLTF files is planned.
  You can provide Egg or Bam files, but it is not recommended for reasons outlined in introduction.
* It is strongly recommended to triangulate any input models if not done so already, but not required.
* The input folder is optional, but recommended to prevent mixing built and input assets.
  It can have any number of levels of nesting, but it is strongly recommended that each folder has only one asset
  inside of it (with all relevant textures). The FBX import step will join all FBX and OBJ files together
  into one model. In addition, putting multiple assets in one folder reduces the caching amount possible.
  For example, this is also a valid structure, albeit I don't recommend it:

.. code-block::

   my-asset/
   ├─ model.blend
   ├─ texture.png
   my-asset2/
   ├─ model2.blend
   ├─ texture2.png
   intermediate/
   built/

* The intermediate folder starts empty. It will be changed over time as models are compiled. It can be
  safely deleted with no consequences except you won't be able to debug a certain compilation step.
  We recommend gitignoring this folder.
* The built folder starts empty and will be populated with models and textures. It can be usually copied
  into the game assets folder directly. It can be deleted, forcing the models to be recompiled.
  We recommend gitignoring it and/or adding a submodule in the same place.
* The scripts folder is optional. It is used here: :doc:`scripting` for normal scripts
* The bscripts folder is optional. It is used here: :doc:`scripting` for scripts intended to be run in Blender
* The common folder is optional. It is used here: :doc:`misc`

Running asset pipeline
----------------------

The pipeline for a model can be launched through a command like this:

.. code-block:: console

   (.venv) $ python -m panda_utils.assetpipeline path/to/input_folder {models-folder} {texture-folder} [step1] [step2] [...]

Each step is a string containing the step name, followed by zero or more arguments separated by colons.
Alternatively, the step can use a special string ``[]`` or a special string ``{}`` instead of the arguments.
Both of these strings mean the command's arguments will be taken from model configuration (see below).
The difference is how these handle commands without set configuration:
``[]`` will not run the command at all, and ``{}`` will run the command with no parameters.
Here are some examples of steps:

.. code-block::

   blend2bam
   downscale:256:10
   collide[]
   yabee{}

Here, ``blend2bam`` will be called without arguments, ``downscale`` will be called with arguments ``256`` and ``10``,
and ``collide`` and ``yabee`` will be called with arguments derived from the model configuration.
``collide`` will not run if the parameters are not configured in model config, ``yabee`` will run with no parameters.

``models-folder`` and ``texture-folder`` are the folder names which are used as paths inside the built folder.
There are multiple standard options how to set these folders:

* The way used by Disney's MMOs sets ``models-folder`` to ``phase_X/models/category_name``
  and ``texture-folder`` to ``phase_X/maps``.
* A modern way which sets both of these folders to ``feature_name`` or ``feature_category/feature_name``.

The Pipeline sets no limitations on these folder names, and you can use any way you want, but I recommend
choosing one of the ways above or something else intuitive and sticking to it for the entire project.
Note that anything that's not the Disney's way is only fully supported since version 1.6b3
(which is currently under development) and will give cryptic errors if used.

The steps are called in order they appear on the command line, for example:

.. code-block:: console

   (.venv) $ python -m panda_utils.assetpipeline input/ phase_1/models/char phase_1/maps blend2bam bam2egg collide[] egg2bam

This command will first run the ``blend2bam`` step with no arguments,
followed by ``bam2egg`` with no arguments,
followed by ``collide`` deriving the arguments from the model configuration (see below),
finally followed by ``egg2bam`` with no arguments.

Some steps include the ``flags`` parameter. This parameter includes zero or more flags, separated by commas.
It can also be set as a list if using model configuration.

The possible steps are described on other pages in this category.

.. note:: in the examples further, ``python -m panda_utils.assetpipeline {input_folder} {phase} {category}``
   will be substituted with ``assetpipeline`` to reduce docs bloat.

Model configuration
-------------------

For easier control over arguments, the input folder can optionally include a file ``model-config.yml``.
This file is supposed to map to a Python dictionary, and the values can be one of these types below:

.. code-block:: yaml

   step_name1: argument_name
   step_name2:
     - arg1
     - arg2
   step_name3:
     kw1: value1
     kw2: value2
   step_name4:
     - kw1: value1
       kw2: value2
     - kw1: value3
       kw2: value4

Whenever a ``step_name[]`` step or a ``step_name{}`` step is encountered, it is processed as follows:

* If ``step_name`` is not in the config file, this step does not run at all (if it's defined as ``step_name[]``)
  or is run without any arguments (if it's defined as ``step_name{}``).
* If ``step_name`` is provided as a string, it is used as the only argument to the step.
  For example, ``step_name1[]`` with the file above is equivalent to ``step_name1:argument_name``.
* If the step configuration is a list (like ``step_name2`` and ``step_name4`` above), it will run multiple times,
  using each list item for arguments. For example, ``step_name2`` will be called once with argument ``arg1``
  and then once again with argument ``arg2``. This procedure is not recursive.
* If the step configuration is a dictionary (like ``step_name3`` and ``step_name4`` above), it will use
  the dictionary as keyword arguments to the step. If it is a list of dictionaries, it will run multiple times,
  using each dictionary as a separate set of keyword arguments. For example:

.. code-block:: yaml

   collide:
     - group_name: cube.010
       method: polyset
       flags: keep,descend
     - group_name: coll_only_solid
       method: polyset
       flags: descend

The steps documentation includes the names of keyword arguments to enable this behavior.

Logging
-------

Normally the pipeline does not log anything. Logging can be enabled by setting one or more environmental variables:

* ``PANDA_UTILS_LOGGING`` for most logs;
* ``PANDA_UTILS_BLENDER_LOGGING`` for blender-related operations;
* ``PANDA_UTILS_P3D_DEBUG`` for Panda3D binaries such as egg-optchar.

Any non-empty value will enable logging.

Logging can be also enabled with the ``pipeline``, ``blender``, and ``p3d`` logging scopes, respectively.
For example, setting the environmental variable ``PANDA_UTILS_DEBUG=pipeline,p3d``
will enable logging for the pipeline itself and Panda3D binaries. Setting the scope to ``all`` enables all scopes.
