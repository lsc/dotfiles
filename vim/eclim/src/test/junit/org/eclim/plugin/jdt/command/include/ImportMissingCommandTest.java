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
package org.eclim.plugin.jdt.command.include;

import org.eclim.Eclim;

import org.eclim.plugin.jdt.Jdt;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Test case for ImportMissingCommand.
 *
 * @author Eric Van Dewoestine
 */
public class ImportMissingCommandTest
{
  private static final String TEST_FILE =
    "src/org/eclim/test/include/TestImportMissing.java";

  @Test
  public void execute()
  {
    assertTrue("Java project doesn't exist.",
        Eclim.projectExists(Jdt.TEST_PROJECT));

    String result = Eclim.execute(new String[]{
      "java_import_missing", "-p", Jdt.TEST_PROJECT, "-f", TEST_FILE
    });

    System.out.println(result);

    assertEquals("Wrong results", result, "[{'type': 'List','imports': ['java.awt.List','java.util.List']},{'type': 'ArrayList','imports': ['java.util.ArrayList']},{'type': 'FooBar','imports': []}]");
  }
}
