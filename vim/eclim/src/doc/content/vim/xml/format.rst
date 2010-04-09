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

.. _vim/xml/format:

.. _\:XmlFormat:

Xml Format
==========

On occasion you may encounter some xml content that is unformatted (like raw
content from a web service).

.. code-block:: xml

  <blah><foo>one</foo><bar>two</bar></blah>

Executing **:XmlFormat** will reformat the current xml file like so\:

.. code-block:: xml

  <blah>
    <foo>one</foo>
    <bar>two</bar>
  </blah>
