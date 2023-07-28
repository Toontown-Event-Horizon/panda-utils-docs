Asset Pipeline
==============

Panda Utils includes a full-fledged Asset Pipeline that can be used to import Blend and/or FBX models into the game,
applying various processing stages to the model. It is also Makefile-ready, which means if attached to a Makefile,
changing a few assets only causes those assets to be rebuilt. (There is currently no publicly accessible Makefile
generator tailored to use with this pipeline.)

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

Some notes about this structure:

* The model files can be Blend-files (made in Blender) or FBX-files (made in any other software).
  There is limited support for OBJ files (not recommended), and support for GLTF files is planned.
  You can provide Egg or Bam files, but it is not recommended for reasons outlined in introduction.
* It is strongly recommended to triangulate any input models if not done so already, but not required.
* The input folder is optional, but recommended to prevent mixing built and input assets.
  It can have any number of levels of nesting, but it is strongly recommended that each folder has only one asset
  inside of it (with all relevant textures). The FBX import step will join all FBX and OBJ files together
  into one model. In addition, putting multiple assets in one folder reduces the caching amount possible.
* The Blend2Bam step is especially fragile and will cease to work if the textures are not in the same folder
  with the model. It is a workaround for a Panda3D limitation. This step is required for 3D workflows,
  so the textures have to be in the same folder with the model.
* The intermediate folder starts empty. It will be changed over time as models are compiled. It can be
  safely deleted with no consequences except you won't be able to debug a certain compilation step.
  We recommend gitignoring this folder.
* The built folder starts empty and will be populated with models and textures. It can be usually copied
  into the game assets folder directly. It can be deleted, forcing the models to be recompiled.
  We recommend gitignoring it and/or adding a submodule in the same place.
* The scripts folder is optional. It is used here: :doc:`scripting`
* The common folder is optional. It is used here: :doc:`misc`

Running asset pipeline
----------------------

The pipeline for a model can be launched through a command like this:

.. code-block:: console

   (.venv) $ python -m panda_utils.assetpipeline path/to/input_folder {phase_X} {category} [step1] [step2] [...]

Each step is a string containing the step name, followed by zero or more arguments separated by colons.
Alternatively, the step can use a special string ``[]`` instead of the arguments, which means
its arguments will be taken from model configuration. Here are some examples of steps:

.. code-block::

   blend2bam
   downscale:256:10
   collide[]

Here, ``blend2bam`` will be called without arguments, ``downscale`` will be called with arguments ``256`` and ``10``,
and ``collide`` will be called with arguments derived from the model configuration.

The steps are called in order they appear on the command line, for example:

.. code-block:: console

   (.venv) $ python -m panda_utils.assetpipeline input_folder phase_1 char blend2bam bam2egg collide[] egg2bam

This command will first run the ``blend2bam`` step with no arguments,
followed by ``bam2egg`` with no arguments,
followed by ``collide`` deriving the arguments from the model configuration,
finally followed by ``egg2bam``.

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

Whenever a ``step_name[]`` step is encountered, it is processed as follows:

* If ``step_name`` is not in the config file, this step does not run at all.
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

Normally the pipeline does not log anything. Logging can be enabled by setting one or both environmental variables:

* ``PANDA_UTILS_LOGGING`` for most logs
* ``PANDA_UTILS_BLENDER_LOGGING`` for blender-related operations.
