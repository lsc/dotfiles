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

.. _vim/php/complete:

Php Code Completion
===================

Php code completion uses the standard
:ref:`Vim code completion mechanism <vim/code_completion>` like so\:

.. code-block:: php

  <?php
  class Test {
    function getName () {
    }
    function getValue () {
    }
  }

  $test = new Test();

  $test->get<C-X><C-U>
  $test->getName()
  ?>

.. note::
  This feature depends on the eclipse pdt_ which should be installed for you
  when choosing php support in the eclim installer.

.. _pdt: http://eclipse.org/pdt
