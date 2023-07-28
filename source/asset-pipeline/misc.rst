Miscellanous steps
==================

Common Texture Set
------------------

In certain cases, there can be multiple models using the same set of textures.
An example is toon heads which all use the eye textures.
This step can be used to copy the textures into the intermediate folder
and then into the built folder.

.. note:: This step will then remove the textures from the built folder after the model is done.
   This means they will have to be copied separately.

.. note:: This step also does not edit the EGG file to set the correct texture set paths.
   This means a separate script will be needed to change the paths if they're not in the same folder
   with the "main" textures.

Arguments
~~~~~~~~~

This step accepts two arguments:

* ``injection_name``: the name of the folder with the textures.
  The pipeline will look for the textures in ``common/{injection_name}``.
* ``copy_path``: the name of the output folder.
  Before building, the textures will be copied into ``phase_X/maps/{copy_path}``.

Examples
~~~~~~~~

* ``cts:all_coins:extras/coins``
