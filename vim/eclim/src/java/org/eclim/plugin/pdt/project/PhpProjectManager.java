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
package org.eclim.plugin.pdt.project;

import org.eclim.plugin.dltk.project.DltkProjectManager;

import org.eclipse.dltk.core.DLTKLanguageManager;
import org.eclipse.dltk.core.IDLTKLanguageToolkit;

import org.eclipse.php.internal.core.project.PHPNature;

/**
 * Implementation of {@link org.eclim.plugin.core.project.ProjectManager} for
 * php projects.
 *
 * @author Eric Van Dewoestine
 */
public class PhpProjectManager
  extends DltkProjectManager
{
  /**
   * {@inheritDoc}
   * @see DltkProjectManager#getLanguageToolkit()
   */
  @Override
  public IDLTKLanguageToolkit getLanguageToolkit()
  {
    return DLTKLanguageManager.getLanguageToolkit(PHPNature.ID);
  }
}
