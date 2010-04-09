# Copyright (C) 2005 - 2008  Eric Van Dewoestine
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Sed script which processes the file ~/.eclimrc, to grab the nailgun port
# number which the eclim client will use to connect to the eclimd server.
# Usage: sed -n -f eclim.sed ~/.eclimrc

# delete any line not containing nailgun.server.*
/^\s*nailgun.server.\(.*\)=/!d

# remove all leading spaces.
s/^\s\+//g

# block to process portions spanning across lines.
H
${
  g
  # remove line continuation chars.
  s/\\\s*//g
  # remove all new line characters
  s/\n/ /g
  # convert properties to nailgun arguments.
  s/nailgun.server.\(\w*\)\s*=\s*\(\w*\)\s*/ --nailgun-\1 \2/g
  p
}
