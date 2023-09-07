Egg-Optchar tool
================

Panda3D includes a very powerful tool Egg-Optchar which does not have a proper documentation
aside from running ``egg-optchar -h``. This document is not intended to be a full documentation
of this tool, instead it serves to explain the functionality used in the ``optchar`` step of the pipeline.

Flagged Nodes
-------------

By default, Panda3D optimizes the geometry of actors, hiding all <Group>s from the programmer interaction.
Sometimes this is undesired. A common example is having replaceable textures applied to actors.
Since all Groups are hidden, it would be impossible to load a texture and apply it to a part of the actor.
In this case, the desired part has to be flagged.

Note that this should not be used to join other models to the actor. See exposed joints below.

Example model config
~~~~~~~~~~~~~~~~~~~~

.. code-block:: yaml

   optchar:
     flags:
       - texturable-node

Example code
~~~~~~~~~~~~

.. code-block:: python

   from direct.actor.Actor import Actor

   modelRoot = Actor()
   modelRoot.loadModel("some-character-model.bam")
   tex = loader.loadTexture("some-texture.png")
   modelRoot.find("**/texturable-node").setTexture(tex, 1)

Exposed Joints
--------------

Flagged nodes have an issue when a model has to be joined to the actor: the nodes are moved by the joints,
but do not actually inherit their transforms. To attach a model to the actor and let it be moved,
the model has to be attached to a joint. By default, all joints are also hidden from the scene graph,
but can be exposed to the user through egg-optchar.

Example model config
~~~~~~~~~~~~~~~~~~~~

.. code-block:: yaml

   optchar:
     expose:
       - joint_head

Example code
~~~~~~~~~~~~

.. code-block:: python

   from direct.actor.Actor import Actor

   modelRoot = Actor()
   modelRoot.loadModel("some-character-model.bam")
   head = modelRoot.find("**/joint_head")
   hat = loader.loadModel("some-hat.bam")
   hat.reparentTo(head)

Nullified Joints
----------------

In some special cases (i.e. multipart rigs or faulty rigs), the animations can move bones it should not move.
For example, animations on the upper part of a humanoid actor would move the torso joint when it actually should be
not moving (depending on the model structure). Therefore, a joint can be nullified in an animation, preventing
any movements of that joint.

Note that nullification applies to the animations, not the model itself. The optchar step will apply nullification
to each model with a file name different from the input folder name (which is sadly, the only reasonable way
to list all animations I can think of).

Egg-optchar also allows partially nullifying a joint by letting it moving in only some axis
(for example, forbidding p rotation but allowing h rotation, etc.) I don't currently know the usecases for this,
but optchar step allows setting the nullified axis after a comma (see example below).

Example model config
~~~~~~~~~~~~~~~~~~~~

.. code-block:: yaml

   optchar:
     zero:
       - root_joint
       - constrained_joint,xypr
