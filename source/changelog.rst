Changelog
=========

Breaking changes are displayed with the 💥 collision symbol.

Versions were not saved before 1.0, so those are not in the changelog.

1.4.0
-----

Asset Pipeline
~~~~~~~~~~~~~~

* Blend2Bam step now has flags (legacy, bullet, srgb, b2b) - Wizzerinus
* 💥 Blend2Bam step now defaults to direct GLTF compilation - Wizzerinus
* 💥 Script step now only works on Python scripts - Wizzerinus
* 💥 Changed semantics of the Script step - Wizzerinus
* Pipeline is now functional on Windows - Wizzerinus
* Support ``PANDA_UTILS_BLENDER_LOGGING`` environmental variable - Wizzerinus

1.3.4
-----

Core
~~~~

* Panda3D path detection now works on Windows - Wizzerinus

Asset Pipeline
~~~~~~~~~~~~~~

* Eggtree steps now cache the input tree, resulting in increased performance - Wizzerinus

1.3.3
-----

Asset Pipeline
~~~~~~~~~~~~~~

* Model Configuration now can apply single argument steps positionally - Wizzerinus
* Added Remove Materials step - Wizzerinus
* Added Transparent step - Wizzerinus
* Collide step will now only save the model if it changed - Wizzerinus

1.3.2
-----

Asset Pipeline
~~~~~~~~~~~~~~

* Collide step now can use collision bitmasks - Wizzerinus

1.3.1
-----

Asset Pipeline
~~~~~~~~~~~~~~

* Palettes will now be consistently ordered - Wizzerinus
* Fixed inconsistencies with Blend2Bam step - Wizzerinus
* Collide step will now detect segmentation faults and fix them - Wizzerinus
* Default timeout for Panda3D operations is now 10 seconds - Wizzerinus
* Fixed ``PANDA_UTILS_LOGGING`` not working - Wizzerinus

1.3.0
-----

Egg Tree
~~~~~~~~

* Space is now valid in the egg node name - Wizzerinus

Asset Pipeline
~~~~~~~~~~~~~~

* 💥 Optimize no longer uses a type - Wizzerinus
* 💥 Optimize no longer sets a model parent - Wizzerinus
* Added Group Rename step - Wizzerinus
* Added Optchar step - Wizzerinus
* Added Group Remove step - Wizzerinus
* Added Model Parent step - Wizzerinus

1.2.1
-----

Asset Pipeline
~~~~~~~~~~~~~~

* 💥 3D-Palettize is now Palettize, and supports flags - Wizzerinus
* Added Downscale step - Wizzerinus
* Added Texture Cards step - Wizzerinus

1.2
---

Egg Tree
~~~~~~~~

* Fixed ``set_texture_prefix`` not working if the texture path is not quoted - Wizzerinus

Asset Pipeline
~~~~~~~~~~~~~~

* 💥 Preblend step will now join all models together - Wizzerinus
* Asset Pipeline now supports model configuration - Wizzerinus
* Added 3D-Palettize step - Wizzerinus
* Fixed inconsistencies with texture filenames - Wizzerinus
* Texture paths are now remapped during Egg2Bam instead of Optimize - Wizzerinus

1.1
---

Core
~~~~

* Panda Utils is now in PyPI
* Implemented Asset Pipeline - Wizzerinus
* Config file is now loaded from a platform-specific place instead of the download folder - Wizzerinus

CLI
~~~

* ``copy`` script can copy directories now - Wizzerinus

1.0
---

Core
~~~~

* Use ``logging`` instead of prints where applicable - Wizzerinus
* Allow finding Panda3D binaries in venv - Wizzerinus