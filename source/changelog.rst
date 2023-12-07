Changelog
=========

Breaking changes are displayed with the 💥 collision symbol. Only changes that are likely to break the workflow
of a user are considered breaking. The changes that affect the internal structure of the built/ folder and such
(when using Asset Pipeline) are *not* considered breaking. Bugfixes are also not considered breaking
unless I believe the bug had a legitimate usecase.

Versions were not saved before 1.0, so those are not in the changelog.

1.6
---

Core
~~~~

* Panda3D callbacks can now be debugged - Wizzerinus
* Streamlined debugging environmental variables - Wizzerinus

Egg Tree
~~~~~~~~

* Values in Egg Leaves will be properly stripped of spaces upon loading - Wizzerinus
* LOD Switch nodes (``<Distance>``) will not cause a pipeline crash now - Wizzerinus

Pipeline
~~~~~~~~

* YABEE will now patch the texture paths before exporting the model - Wizzerinus
* YABEE will now work if the Blender model was saved in pose mode - Wizzerinus
* Egg2bam now uses ``filter`` flag instead of ``alltex`` - Wizzerinus
* 💥 Optimize step now uses flags - Wizzerinus
* Optimize step will now replace transparent vertex coloring with white - Wizzerinus

  * This is a workaround for a weird behavior in Blender. It is already included in our version of YABEE,
    and is now available for the use in other workflows (i.e. Blend2bam).
  * Due to being experimental, this can be disabled by passing the ``keep_transparent_vertices`` flag.
* Script step can now accept parameters - Wizzerinus
* Added blender-script step - Wizzerinus
* ``egg2bam`` will now also copy rgb texture files - Wizzerinus
* The asset pipeline now fully works with assets in subfolders - Wizzerinus
* Added support for relative texture paths - Wizzerinus
* ``collide`` step and ``uvscroll`` step can be configured using fnmatch patterns - Wizzerinus


Composer
~~~~~~~~

* Actor exporter will default to loading optchar settings from the model config file - Wizzerinus
* Composer will now consider folders with ``model-config.yml`` and subfolders assets - Wizzerinus
* ``cts[]`` step will now enable dependency management - Wizzerinus
* Composer can now be started from any subfolder of the asset tree - Wizzerinus

1.5.4
-----

Pipeline
~~~~~~~~

* Egg2bam step now uses flags instead of a boolean value - Wizzerinus
* Palettize step can have exclusions configured with a fnmatch pattern now - Wizzerinus

Composer
~~~~~~~~

* Extra steps can require production or development mode now - Wizzerinus

1.5.3
-----

Core
~~~~

* Downscale will no longer upscale small textures - Wizzerinus
* Copy can copy single files again - Wizzerinus

Pipeline
~~~~~~~~

* Added Zero argument to Optchar - Wizzerinus
* Downscale will no longer upscale small textures - Wizzerinus
* 💥 Downscale will no longer work in Force mode by default - Wizzerinus

1.5.2
-----

Pipeline
~~~~~~~~

* Fixed conversion errors for models with relative paths on Windows - Wizzerinus
* Optimize step now deletes UV names from models - Wizzerinus
* Added uv scroll step - Wizzerinus
* Added uncache step for debugging - Wizzerinus
* Optimize step will properly ignore palettes when counting the textures and renaming them - Wizzerinus

Composer
~~~~~~~~

* Import method can now be overridden on a per-model basis (on addition to the per-group basis) - Wizzerinus

1.5.1
-----

Composer
~~~~~~~~

* Inserting steps after or before steps such as ``egg2bam`` no longer results in a parse error - Wizzerinus
* ``egg2bam``, ``preexport``, and ``optchar`` steps now can be configured from the targets file - Wizzerinus

1.5
---

Core
~~~~

* Introduced a new Composer tool - Wizzerinus (1.5)

Asset Pipeline
~~~~~~~~~~~~~~

* 💥 The YABEE step now requires TTEVH's fork of YABEE
* The YABEE step can now export animations - Wizzerinus
* 💥 The Optchar step will now export only the model whose name matches the name of the folder - Wizzerinus
* Fixed Transparency step breaking already transparent textures - Wizzerinus
* Fixed Palettize step deleting textures that did not fit the palette - Wizzerinus
* 💥 Asset Pipeline now accepts ``model_output`` and ``texture_output`` as the commandline parameters instead of ``output_phase`` and ``output_folder`` - Wizzerinus (1.5)
* Pipeline can now use ``{}`` for parameters - Wizzerinus
* YABEE now works on blend files that were saved outside of object mode - Wizzerinus
* Added ``delete_vertex_colors`` step - Wizzerinus
* Fixed Palettize step removing texture looping - Wizzerinus
* Asset Pipeline will delete all textures when rebuilding a model - Wizzerinus

Egg Tree
~~~~~~~~

* Better compatibility with models exported through YABEE - Wizzerinus (1.5b2)

1.4.4
-----

Asset Pipeline
~~~~~~~~~~~~~~

* Palette generation can now skip images on demand - Wizzerinus
* Optimize step will no longer rename palettes - Wizzerinus

1.4.3
-----

Asset Pipeline
~~~~~~~~~~~~~~

* Use Pathlib in pipeline to improve windows compatibility - Wizzerinus

1.4.2
-----

Asset Pipeline
~~~~~~~~~~~~~~

* 💥 Common Texture Set now only accepts one argument - Wizzerinus
* 💥 Egg2Bam step no longer copies textures injected through Common Texture Set - Wizzerinus
* Egg2Bam with all_textures set to true will now respect the texture paths in egg file - Wizzerinus

1.4.1
-----

Asset Pipeline
~~~~~~~~~~~~~~

* Added YABEE Export step - Wizzerinus
* Added Common Texture Set step - Wizzerinus
* Optimize step may have its texture remapping operation disabled - Wizzerinus
* Egg2Bam step may now optionally copy all textures instead of linked textures - Wizzerinus

Egg Tree
~~~~~~~~

* ``set_texture_prefix`` will no longer affect textures that start with the prefix - Wizzerinus

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
