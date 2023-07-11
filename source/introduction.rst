Introduction to Panda Utils
===========================

Panda Utils is a set of Python scripts meant to help various projects running on the game engine
`Panda3D <https://panda3d.org>`_.
It includes tools for manual use, as well as a full-fledged asset importing pipeline.
It also includes an implementation of Egg Syntax Tree, which can be used programmatically in some scenarios.

Panda Utils is fairly opinionated, based on our experience with the Toontown source code:

* We use Egg files as an intermediate development step, and Bam files as the game-ready format.
  Some modern projects ditch Egg files altogether (sometimes even Bam files) and use GLTF and/or Assimp
  to handle models. In such cases, Panda Utils will be of little use.
* We believe storing intermediate asset files (Bam, Egg, etc.) is not a good practice. Therefore,
  asset pipeline uses formats such as Blend and FBX for the input files. If you like
  having Bam/Egg files as your main source of truth, the asset pipeline will not be very useful.
  You still can use the manual pipeline if you do that.
* In the same way, we separate the game's assets folder and the intermediate assets folder.
  It is commonly referred as the "workspace folder" and determined by checking the cwd
  (current working directory).
* We do not join palettes of multiple different models together. Doing so may reduce the project size
  in some cases.
* The tool enforces a certain structure on the ``resources`` folder of your project.
  It is relatively flexible, but may not be desired in some cases. The structure looks like this
  (the top-level folders do not have to be named ``phase_N`` and can have any name):

.. code-block::

   resources/
   ├─ phase_1/
   │  ├─ models/
   │  │  ├─ category/
   │  │  |  ├─ asset-name.bam
   │  │  |  ├─ other-asset.bam
   │  │  |  ├─ ...
   │  ├─ maps/
   │  │  ├─ asset-name.png
   │  │  ├─ asset-name-1.png
   │  │  ├─ asset-name-2.png
   │  │  ├─ other-asset.png
   │  │  ├─ ...
   ├─ phase_2/
   │  ├─ models/
   │  │  ├─ ...
   │  ├─ maps/
   │  │  ├─ ...
   ├─ ...

* We usually use semi-absolute texture paths (i.e. ``phase_1/maps/asset-name.png``) instead of model-relative
  (i.e. ``../../maps/asset-name.png``). This requires proper Panda3D configurtion and also does not allow copying
  models around between phases.


.. warning:: The Egg syntax tree module does not guarantee the validity of the Egg file after any operation.
   For example, you can insert a node with an invalid name into the tree, or insert a ``<Collide>`` node
   into a group with non-polygon objects under it. If you don't do those, the model should be usable.
   It also may reject valid egg files built with a non-standard generator
   (generators like bam2egg or panda-utils itself are safe).

Panda Utils requires at least Python 3.8 and a reasonably contemporary version of Panda3D.

.. warning:: Panda Utils is not compatible with Panda3D 1.10.13. This is due to some change in the
   Panda's compilation process which broke Egg-Trans tool actively used inside Panda Utils. You can
   check whether your version of Panda is compatible by running ``egg-trans`` from the command line.
   If it outputs a help notice, it probably works, 1.10.13 causes segmentation faults and will not work.

.. note:: The support for Windows machines is currently a Work-in-progress and not guaranteed to work.
   We're working on improving it over time.

Panda Utils can be installed from Pip:

.. code-block:: console

   (.venv) $ pip install panda-utils

Panda Utils also includes a number of optional dependencies:

* ``imagery`` downloads Pillow. Pillow is required to run the ``downscale`` actions
  (manually or through the pipeline).
* ``autopath`` downloads Panda3D. Normally, Panda3D is installed separately and exposed to Panda Utils
  through path, however contexts can also find the Panda3D in the project's venv.
  This is primarily used for asset pipeline.
* ``runnable`` downloads Platform Dirs. This is required for the manual use part.
* ``pipeline`` downloads Pyyaml, Panda3D, Blend2Bam, Gltf2Bam, and Numpy. This is required to use the
  asset pipeline. Note that this is a big installation (~300 MB), but it is required as Blender will
  not run in a venv without numpy, and certain model operations require Panda3D. If downscale is
  used in the workflow, imagery dependency is needed separately.
* ``everything`` can be used to install all of the dependencies above.

All of these dependencies can be installed through Pip, for example:

.. code-block:: console

   (.venv) $ pip install panda-utils[imagery,autopath,runnable]

.. note:: You might need to quote the package name on Linux if installing optional dependencies,
   since some shells (in particular Zsh) will expand the square brackets otherwise.

* :doc:`manual-use/introduction`
* :doc:`egg-trees/introduction`
* :doc:`asset-pipeline/introduction`
