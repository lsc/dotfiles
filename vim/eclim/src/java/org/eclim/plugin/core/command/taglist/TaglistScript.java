/**
 * Copyright (C) 2005 - 2009  Eric Van Dewoestine
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.eclim.plugin.core.command.taglist;

/**
 * Defines a script for processing tags in a file.
 *
 * @author Eric Van Dewoestine
 */
public interface TaglistScript
{
  /**
   * Executes this script on the supplied file.
   *
   * @param file The name of the file to process tags on.
   * @return Array of TagResult.
   */
  public TagResult[] execute(String file)
    throws Exception;
}
