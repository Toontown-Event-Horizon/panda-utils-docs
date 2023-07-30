Miscellanous steps
==================

Common Texture Set
------------------

In certain cases, there can be multiple models using the same set of textures.
An example is toon heads which all use the eye textures.
This step can be used to copy the textures into the intermediate folder
and then into the built folder.

.. note:: This step requires that the textures are copied into the proper folder *before* the pipeline is invoked.

.. note:: This step also does not edit the EGG file to set the correct texture set paths.
   This means a separate script will be needed to change the paths if they're not in the same folder
   with the "main" textures.

Arguments
~~~~~~~~~

This step accepts one argument:

* ``injection_name``: the name of the folder with the textures.
  The pipeline will look for the textures in ``common/{injection_name}``.

Examples
~~~~~~~~

* ``cts:all_coins``
