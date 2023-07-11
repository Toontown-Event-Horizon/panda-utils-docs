Model Extraction
================

Advanced Bam Extractor
----------------------

This script will convert bam files to egg files. Usually, such conversion may fail, if the bam file does not find
the textures on certain path. In that case, this script will try to copy the textures from the project folder.
If it does not find the textures there, it will ask the user to input the texture paths elsewhere.
Afterwards, all textures will be available in the workspace folder.

If the bam file is not present in the workspace, it will be copied from the project folder instead.

.. code-block:: console

   (.venv) $ python -m panda_utils bam2egg phase_3/models/char/random-model.bam

Advanced Egg2Bam converter
--------------------------

This script is mostly the same as the Advanced Bam Extractor, but works in the opposite way.
The only difference is that it will not try to copy the egg file from the project folder.

.. code-block:: console

   (.venv) $ python -m panda_utils egg2bam phase_3/models/char/random-model.egg
