.. Copyright (C) 2005 - 2009  Eric Van Dewoestine

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

.. _vim/java/hierarchy:

Class / Interface Hierarchy
===========================

.. _\:JavaHierarchy:

When viewing a java class or interface you can view the type hierarchy by
issuing the command **:JavaHierarchy**.  This will open a temporary buffer with
an inversed tree view of the type hierarchy with the current class / interface
at the root.

.. code-block:: java

  public class XmlCodeCompleteCommand
    public class WstCodeCompleteCommand
      public class AbstractCodeCompleteCommand
        public class AbstractCommand
          public interface Command

Inner classes / interfaces are also supported.  Just place the cursor on the
inner class / interface before calling **:JavaHierarchy**.

While you are in the hierarchy tree buffer, you can jump to the type under the
cursor using one of the following key bindings:

  - <enter> - open the type using the
    (:ref:`default action <g:EclimJavaHierarchyDefaultAction>`).
  - <ctrl>e - open the type via :edit
  - <ctrl>s - open the type via :split
  - <ctrl>t - open the type via :tabnew


Configuration
-------------

Vim Variables

.. _g\:EclimJavaHierarchyDefaultAction:

- **g:EclimJavaHierarchyDefaultAction** (defaults to 'split') -
  Determines the command used to open the type when hitting <enter> on the type
  entry in the hierarchy buffer.
