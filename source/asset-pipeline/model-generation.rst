Model Generation
================

Downscale
---------

This step rescales all images in the input folder.

.. note:: This step requires the ``imagery`` optional dependency.

Arguments
~~~~~~~~~

This step accepts up to four arguments.

* The first argument ``size`` is required.
  The desired texture size, which has to be a power-of-two.
  All affected textures will be resized to ``size * size``.
* The second parameter ``bbox`` is optional.
  If it is not present, the textures will be resized as-is.
  If it is present, all textures will be first cropped to their bounding box before resizing
  with ``bbox%`` padding around the bounding box.
  For example, setting ``bbox=10`` will use 10/12th of each dimension for the source image,
  and 1/12th of each dimension on each side for the padding.
  To skip this parameter (if using the string notation), use -1 (*not* empty string).
  If this parameter is 0 or greater ``force`` flag will be implied.
* The third parameter ``flags`` is optional. It defaults to no flags. The options are:

  * ``force``: By default, only square textures will be resized. This flag enables rescaling of rectangular textures.
    Note that this flag has no effect on square textures with the size smaller than the target size,
    which will not be rescaled in either case.
  * ``truecenter``: By default, if force mode is used,
    textures with big width and small height will be pinned to the bottom of the image.
    Setting this flag will instead center those textures in the image.
    This flag does not affect the textures with small width and big height, which will always be centered.
    Enabling this flag implies ``force``.
* The fourth argument ``name`` is optional, and defaults to an empty string.
  If name is empty, all textures will be resized.
  If name is not empty, only the texture matching the given name will be resized.
  This accepts Unix-style patterns (i.e. ``background-*.png``).

Examples
~~~~~~~~

* ``downscale:256``
* ``downscale:256:10``
* ``downscale:256:-1:truecenter:background-*.png``
* ``downscale[]``



Texture Cards
-------------

This step is used to create an EGG model out of a set of png files.
It is usually used to combine multiple related 2D images/icons together.
It is recommended to do ``downscale`` before this step, and ``palettize`` after this step, but not required.

Arguments
~~~~~~~~~

This step accepts one argument ``size``. By default it is not present.
If it is present, it should be an integer, usually power-of-two.
By default, all parts of the model will occupy the 1x1 unit square when loaded in Panda3D.
This is usually desired for assets such as icons, but not desired for assets with variable sizes
or non-uniform aspect ratio, such as GUI elements.
If this argument is set, textures will occupy space based on their size in pixels,
and images with width=height=size will occupy the unit square in Panda3D.
For example, if this argument is set to 512, 256x256 textures will have the Panda3D size 0.5x0.5,
and 128x1024 textures will have the size 0.25x2.

Examples
~~~~~~~~

* ``texture_cards``
* ``texture_cards:512``

