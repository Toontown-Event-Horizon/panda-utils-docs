Model Postprocessing
====================

.. warning:: The package includes some other commands (i.e. ``pipeline``, ``tbn``) which are not documented here.
   Those commands are not supported. Use at your own risk.

Toon Head export
----------------

This script allows exporting toon heads. I suspect it also helps with exporting some other models planted
on top of a multipart actor. It is not guaranteed to work on all sources, but technical support and/or bugfixes will
be provided for publicly available sources.

In particular this script:

* Structures the Dart of the head, which apparently fixes some functionality with multipart actors.
  Note that this may be required even for non-animated toon heads
* Deletes all material references
* Deletes all UV map names
* Makes all texture references of the model semitransparent (adding ``<Scalar> alpha { dual }`` tag)

It requires two things:

* The head has to be exported as an egg file
* Textures for the head have to be located in ``phase_3/maps``

The egg file will be modified in place, and a bam file will be created in the same directory.

.. code-block:: console

   (.venv) $ python -m panda_utils toonhead deer-head.egg

This step has the following optional arguments:

* **Triplicate:** since toons use LOD, the head has to be copied three times on most sources. This argument
  will copy the head three times. Note that it does not apply decimation, so if you want to decimate your head
  you should run this script on three versions of the egg file.

.. code-block:: console

   (.venv) $ python -m panda_utils toonhead deer-head.egg --triplicate


Animation Rename
----------------

This script is used to rename animations in a set of animation files. It accepts two folders. One has bam files,
the other will be populated with patched bam files. It can be used to substitute the rig used for animations.

.. code-block:: console

   (.venv) $ python -m panda_utils animrename input_folder output_folder old-joint=NewJoint,old-joint2=NewJoint2

.. note:: It is recommended to use ``fromfile`` for long lists of joints to prevent typos.
