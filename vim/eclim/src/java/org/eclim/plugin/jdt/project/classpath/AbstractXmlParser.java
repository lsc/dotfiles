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
package org.eclim.plugin.jdt.project.classpath;

import java.io.File;

import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;

/**
 * Abstract base class for parsers that work with xml files.
 *
 * @author Eric Van Dewoestine
 */
public abstract class AbstractXmlParser
  implements Parser
{
  private static DocumentBuilderFactory factory;

  /**
   * {@inheritDoc}
   */
  public Dependency[] parse(String filename)
    throws Exception
  {
    if(factory == null){
      factory = DocumentBuilderFactory.newInstance();
    }

    Document document = factory.newDocumentBuilder().parse(new File(filename));
    return parse(document);
  }

  /**
   * Parse the dependencies from the supplied document.
   *
   * @param document The document.
   * @return The array of Dependency.
   */
  public abstract Dependency[] parse(Document document)
    throws Exception;
}
