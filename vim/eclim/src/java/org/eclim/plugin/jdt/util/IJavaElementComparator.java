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
package org.eclim.plugin.jdt.util;

import java.util.Comparator;

import org.eclipse.jdt.core.IJavaElement;

/**
 * Comparator for sorting IJavaElement(s).
 *
 * @author Eric Van Dewoestine
 */
public class IJavaElementComparator
  implements Comparator<IJavaElement>
{
  /**
   * {@inheritDoc}
   */
  public int compare(IJavaElement o1, IJavaElement o2)
  {
    if(o1 == null && o2 == null){
      return 0;
    }else if(o2 == null){
      return -1;
    }else if(o1 == null){
      return 1;
    }

    IJavaElement p1 = JavaUtils.getPrimaryElement(o1);
    IJavaElement p2 = JavaUtils.getPrimaryElement(o2);

    return p1.getElementType() - p2.getElementType();
  }

  /**
   * {@inheritDoc}
   */
  public boolean equals(Object obj)
  {
    if(obj instanceof IJavaElementComparator){
      return true;
    }
    return false;
  }
}
