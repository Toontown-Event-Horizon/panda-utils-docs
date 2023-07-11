Format Conversion
=================

The following steps can be used to convert models from one format into another.
The general step sequence that imports a 3D model should look like this:

.. code-block:: console

   $ assetpipeline {either preblend or blendrename} blend2bam bam2egg {optimization process here} egg2bam

Any step sequence that outputs a game model (3D or 2D) should end with ``egg2bam`` since that is
the step that copies assets into the built folder as well.

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
--------

This step will rename the BLEND models into their proper name.
It is required if the input files are in BLEND format,
but not required if the Blend files are generated through Preblend.

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

Model exports through other means (YABEE, Blend2bam's Egg pipeline, Boterham)
are currently not implemented, but are considered for use in the future.

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

Egg2Bam
-------

This step is used to assemble the EGG model into the BAM model suitable for ingame use.
It also replaces the texture paths in the model, and copies the model and every needed texture
into the ``built`` folder.

Arguments
~~~~~~~~~

This step takes no arguments.

Examples
~~~~~~~~

* ``egg2bam``
