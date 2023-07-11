Model Generation
================

Image Downscaling
-----------------

This script allows reducing the size of all textures in a given folder to a given size. It also makes backups of
the textures separately.

.. code-block:: console

   (.venv) $ python -m panda_utils downscale random-folder/coins-n-icons 128

The target size can be any of the following values: 32, 64, 128, 256, 512, 1024.

This step has the following optional arguments (which can be combined together):

* **Force:** this will resize the images of non-uniform size in the folder. It makes best effort to
  keep their aspect ratio (by padding the image with transparency).
  By default only perfectly square images will be resized. Usually recommended.

.. code-block:: console

   (.venv) $ python -m panda_utils downscale random-folder/coins-n-icons 128 --force
   (.venv) $ python -m panda_utils downscale random-folder/coins-n-icons 128 -f

(either of these options can be used, same with all subsequent arguments)

* **Bounding Box:** this will first crop the images in such a way that their transparent bounding box
  on each size is X% (where X is a provided integer) of the image's size. For example, if X=10, and an image has
  the bounding box of 128x128, this will leave ~12 pixels on each side of the image, then remove the rest before
  downscaling (even if the original size of the image was large). It is recommended for uniform items like icons,
  but not recommended for items like laff meters, which rely on some part of the geometry being properly scaled.
  This implies ``--force``, because an image might become non-square after cropping to bbox.
  We usually recommend 10% if this is applicable.

.. code-block:: console

   (.venv) $ python -m panda_utils downscale random-folder/coins-n-icons 128 --bbox 10
   (.venv) $ python -m panda_utils downscale random-folder/coins-n-icons 128 -b 10

* **True Center:** normally, if the script encounters a non-square image with ``--force`` enabled, it does one
  of the two following actions. If the image is longer vertically than horizontally, it will be centered in the
  resulting image. Otherwise, it will be pinned to the bottom of the resulting image. If this is used, the
  image will instead be always centered. Only makes sense with ``--force`` (or ``--bbox``) enabled.

.. code-block:: console

   (.venv) $ python -m panda_utils downscale random-folder/coins-n-icons 128 --force --truecenter
   (.venv) $ python -m panda_utils downscale random-folder/coins-n-icons 128 -fc

* **Ignore Current Scale:** normally, only images whose size differs from target size will be rescaled. With this
  argument, all images will be rescaled. Only makes sense with ``--bbox`` enabled.

.. code-block:: console

   (.venv) $ python -m panda_utils downscale random-folder/coins-n-icons 128 --bbox 10 --ignore-current-scale
   (.venv) $ python -m panda_utils downscale random-folder/coins-n-icons 128 -b 10 -I

Palettization
-------------

This script allows building a model consisting of multiple 2D images. It then joins those images together,
making multiple palettes, which increases the efficiency of loading those models from Panda3D.
Each palette has a size of 2048x2048, but can be smaller if the process "runs out of textures".
This size is currently not configurable.
The specific images can be "found" in the model from the game code:

.. code-block:: python

   palette = loader.loadModel("phase_1/models/gui/coins-n-icons.bam")
   coin = palette.find("**/coin-icon")
   diamond = palette.find("**/diamond-icon")
   ...

It expects the following directory structure:

.. code-block::

   resources/
   ├─ phase_1/
   │  ├─ maps/
   │  │  ├─ coins-n-icons/
   │  │  |  ├─ coin-icon.png
   │  │  |  ├─ diamond-icon.png
   │  │  |  ├─ ...

and will create a bam file and an egg file in ``resources/phase_1/models/gui``.

This functionality is built into Panda3D, however, it is pretty annoying to use in some scenarios.

.. note:: It is usually recommended to use this in tandem with Image Downscaling script.
   Having icons of too high resolution will cause graphical issues with Panda3D's reverse mipmap process.

.. code-block:: console

   (.venv) $ python -m panda_utils palettize coins-n-icons phase_1 gui

This step has the following optional arguments (which can be combined together):

* **Poly-size:** by default, each texture will occupy 1x1 square centered at origin when imported into Panda3D.
  This is usually desired when importing icons, but not desired when importing GUI elements, which can be
  of different sizes or aspect ratios. In that case, this argument can be used. It accepts an integer
  (usually power of 2), and makes the model size based on the texture size, so that ``polysize x polysize`` images
  will be imported as 1x1 squares into Panda3D.

.. code-block:: console

   (.venv) $ python -m panda_utils palettize coins-n-icons phase_1 gui --poly 256
   (.venv) $ python -m panda_utils palettize coins-n-icons phase_1 gui -p 256

* **Margin:** if the palettized items have pixels on the edges, loading the palette into Panda3D can cause
  texture bleeding. To prevent this, this argument can be used. It accepts an integer, if the integer is N then
  N pixels on the sides will not be used for the model. Defaults to 0.
  We do not recommend using it for i.e. icons that do not have pixels on the edges.

.. code-block:: console

   (.venv) $ python -m panda_utils palettize coins-n-icons phase_1 gui --margin 2
   (.venv) $ python -m panda_utils palettize coins-n-icons phase_1 gui -m 2

* **Ordered:** this primarily exists to support texture packs. If more images are added to the folder, the palettizer
  will reorder all of the icons in the palettes, rendering texture packs unusable. To prevent this, this argument
  can be used. It allows renaming the images as follows:

.. code-block::

   resources/
   ├─ phase_1/
   │  ├─ maps/
   │  │  ├─ coins-n-icons/
   │  │  |  ├─ 001-coin-icon.png
   │  │  |  ├─ 002-diamond-icon.png
   │  │  |  ├─ ...

If this is used normally, the icons will have names ``001-coin-icon`` etc. in Panda3D, and this argument removes
the integer prefix. With the directory structure not like the one above, this argument has no effect.
Recommended almost always, but not default for various reasons.

.. code-block:: console

   (.venv) $ python -m panda_utils palettize coins-n-icons phase_1 gui --ordered
   (.venv) $ python -m panda_utils palettize coins-n-icons phase_1 gui -O

.. note:: The last page of a palette will have variable size and might become incompatible with texture packs,
   even if this step is used.
