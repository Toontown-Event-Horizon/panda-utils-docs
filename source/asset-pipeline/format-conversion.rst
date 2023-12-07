Format Conversion
=================

The following steps can be used to convert models from one format into another.
The general step sequence that imports a 3D model should look like this:

.. code-block:: console

   $ assetpipeline {preexport} {export} {optimization process here} egg2bam

* ``preexport`` - either ``preblend`` (if the model is made in a software other than blender)
  or ``blendrename`` (if the model is made in Blender). ``blendrename`` may be omitted, but it's not recommended.
* ``export`` - either ``blend2bam bam2egg`` or ``yabee``. YABEE is not supported by the Panda3D devs,
  but we still offer some amount of support. YABEE is also required to export animations (as of this time).

Any step sequence that outputs a game model (3D or 2D) should end with ``egg2bam`` since that is
the step that copies assets into the built folder as well.

Model exporting information
---------------------------

Panda3D's models can be exported through a multitude of scripts:

* `Blend2bam <https://github.com/Moguri/blend2bam>`_;
* `Panda3D GLTF <https://github.com/Moguri/panda3d-gltf>`_;
* The outdated tools ``dxf2egg``, ``flt2egg``, ``lwo2egg``, ``obj2egg``, ``vrml2egg``, ``x2egg``,
  ``dae2egg``, ``maya2egg``, ``maxegg``;
* `Assimp <https://assimp-docs.readthedocs.io/en/latest/about/introduction.html>`_;
* `YABEE <https://github.com/09th/YABEE>`_;
* `Boterham <https://pypi.org/project/panda3d-boterham/>`_.

The use of Assimp is against our philosophy, and the outdated tools are well, not supported.
So there are four main options.

* Blend2Bam was the default method since 1.0.0, however we do not recommend using it as it does not work
  with the texture path modification script on Windows.
* Exporting blend file to gltf followed by gltf2bam is the default method since 1.4.0. It is mostly the same
  as blend2bam except it does not have the issue outlined above.
* YABEE is an experimental method available since 1.4.1. It is less supported than Blend2bam, but can be
  used in cases where Blend2bam fails. The main fundamental difference between YABEE and Blend2bam is
  the fact that Blend2bam exports a scene directly as Panda3D sees it, while YABEE parses the blend file
  and writes out Egg polygons, ignoring the Panda3D's vision of this model. Because of that, YABEE
  can fix various issues that happen when exporting actors not parented to their armature.
  YABEE is also useful when exporting animations, as it allows splitting multiple animations in
  one Blend file.
* Boterham and exporting GLTF models (bypassing Blend files) are currently not supported.

Note that the recent versions of Blender do not support the old versions of YABEE.
We recommend using `our fork <https://github.com/Toontown-Event-Horizon/YABEE>`_ to export through YABEE.
This is required since 1.5b1 due to changes made to allow exporting animations.

Preblend
--------

The Preblend step can be used to transform FBX and OBJ models into BLEND.
All models of these two types will be joined together to make one BLEND model.
Note that due to specifics of various modeling software, the model may end up scaled incorrectly
after this step. You can use the ``transform`` step to fix this.

Arguments
~~~~~~~~~

This step accepts no arguments.

Examples
~~~~~~~~

* ``preblend``

BlendRename
-----------

This step will rename the BLEND models into their proper name.
It is strongly recommended if the input files are in BLEND format,
but has no effect if the Blend files are generated through Preblend.

Arguments
~~~~~~~~~

This step takes no arguments.

Examples
~~~~~~~~

* ``blendrename``

Blend2Bam
---------

This step will use Blend2Bam or Gltf2Bam to convert the BLEND moodels into an intermediate BAM model.
It should happen after ``preblend`` or ``blendrename``.
This model is usually not suitable for ingame use and requires further processing
through ``bam2egg`` and followup steps.

Arguments
~~~~~~~~~

This step accepts one parameter ``flags``. It defaults to empty string, and includes
zero or more comma-separated flags from the following list:

* ``b2b`` - if this flag is present, the exporter uses ``panda3d-blend2bam``.
  If it is not present, the exporter uses Blender's GLTF exporter and ``panda3d-gltf``.
  Note that the blend2bam pipeline currently does not properly export texture paths on Windows,
  so it is recommended to not have this flag unless you have a reason to.
* ``srgb`` - enables the use of sRGB textures. This is the default behavior of ``panda3d-gltf``,
  but it causes certain models to display darker than they look in other software, so it is disabled by default.
* ``bullet`` - enables the use of Bullet collision solids. By default, builtin collision solids are used,
  this has to be enabled if (and only if) your project uses Bullet.
* ``legacy`` - export legacy BAM materials. By default, exports PBR materials.

For other Toontown developers: we use no flags while exporting, but you might want ``legacy`` on some sources.

Examples
~~~~~~~~

* ``blend2bam``
* ``blend2bam:srgb,bullet``

Bam2Egg
-------

This step will decompile every BAM model into EGG models,
which are used for processing through other methods.

Arguments
~~~~~~~~~

This step takes no arguments.

Examples
~~~~~~~~

* ``bam2egg``

YABEE
-----

This step uses YABEE to export BLEND models directly into EGG models. It is run on each model separately,
meaning there will be as many EGG models as there were BLEND models.
It can also export animations from Blender actions. The animations will be exported as separate files.

Arguments
~~~~~~~~~

This step can be run either without arguments or with keyword arguments.

Every keyword argument ``key: value`` will export the Blender Action ``value`` as an animation with the name ``key``.
The animation will be saved into ``{phase}/models/{category}/{modelName}-{key}.bam``.

Examples
~~~~~~~~

* ``yabee``
* ``yabee[]``

Egg2Bam
-------

This step is used to assemble the EGG model into the BAM model suitable for ingame use.
It also replaces the texture paths in the model, and copies the model and every needed texture
into the ``built`` folder.

Arguments
~~~~~~~~~

This step takes up to one argument:

* ``flags``: default ``filter``. Either a string separated by commas or an array.
  * ``filter``: If it is included, only the textures referenced in the egg file are copied (which is the default).
    If it is excluded, all textures will be copied.

Examples
~~~~~~~~

* ``egg2bam``
* ``egg2bam:``
