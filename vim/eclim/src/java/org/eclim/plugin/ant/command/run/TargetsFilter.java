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
package org.eclim.plugin.ant.command.run;

import java.util.List;

import org.eclim.command.CommandLine;
import org.eclim.command.OutputFilter;

/**
 * Filter for command to get ant targets.
 *
 * @author Eric Van Dewoestine
 */
public class TargetsFilter
  implements OutputFilter<List<String>>
{
  public static final TargetsFilter instance = new TargetsFilter();

  /**
   * {@inheritDoc}
   */
  public String filter(CommandLine commandLine, List<String> results)
  {
    StringBuffer buffer = new StringBuffer();
    if(results != null){
      for (String target : results){
        if(buffer.length() > 0){
          buffer.append('\n');
        }
        buffer.append(target);
      }
    }
    return buffer.toString();
  }
}
