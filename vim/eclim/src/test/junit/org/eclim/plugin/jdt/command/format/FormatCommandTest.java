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
package org.eclim.plugin.jdt.command.format;

import org.apache.commons.lang.StringUtils;

import org.eclim.Eclim;

import org.eclim.plugin.jdt.Jdt;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Test case for FormatCommand.
 *
 * @author Eric Van Dewoestine
 */
public class FormatCommandTest
{
  private static final String TEST_FILE =
    "src/org/eclim/test/format/TestFormat.java";

  @Test
  public void oneLine()
  {
    assertTrue("Java project doesn't exist.",
        Eclim.projectExists(Jdt.TEST_PROJECT));

    String contents = Eclim.fileToString(Jdt.TEST_PROJECT, TEST_FILE);
    String[] lines = StringUtils.split(contents, '\n');
    assertEquals("Initial line format incorrect.",
        "System.out.println(\"test formatting\");", lines[22]);

    Eclim.execute(new String[]{
      "java_format", "-p", Jdt.TEST_PROJECT,
      "-f", TEST_FILE,
      "-b", "816", "-e", "855"
    });

    contents = Eclim.fileToString(Jdt.TEST_PROJECT, TEST_FILE);
    lines = StringUtils.split(contents, '\n');
    assertEquals("Result line format incorrect.",
        "\t\tSystem.out.println(\"test formatting\");", lines[22]);
  }

  @Test
  public void range()
  {
    assertTrue("Java project doesn't exist.",
        Eclim.projectExists(Jdt.TEST_PROJECT));

    String contents = Eclim.fileToString(Jdt.TEST_PROJECT, TEST_FILE);
    String[] lines = StringUtils.split(contents, '\n');
    assertEquals("Initial line 1 format incorrect.", "if(true){", lines[23]);
    assertEquals("Initial line 2 format incorrect.",
        "System.out.println(\"test format if\");", lines[24]);
    assertEquals("Initial line 3 format incorrect.", "}", lines[25]);

    Eclim.execute(new String[]{
      "java_format", "-p", Jdt.TEST_PROJECT,
      "-f", TEST_FILE,
      "-b", "855", "-e", "907"
    });

    contents = Eclim.fileToString(Jdt.TEST_PROJECT, TEST_FILE);
    lines = StringUtils.split(contents, '\n');
    assertEquals("Result line 1 format incorrect.", "\t\tif (true) {", lines[23]);
    assertEquals("Result line 2 format incorrect.",
        "\t\t\tSystem.out.println(\"test format if\");", lines[24]);
    assertEquals("Result line 3 format incorrect.", "\t\t}", lines[25]);
  }

  @Test
  public void wholeFile()
  {
    assertTrue("Java project doesn't exist.",
        Eclim.projectExists(Jdt.TEST_PROJECT));

    String contents = Eclim.fileToString(Jdt.TEST_PROJECT, TEST_FILE);
    String[] lines = StringUtils.split(contents, '\n');
    assertEquals("Initial line 1 format incorrect.", "public", lines[18]);
    assertEquals("Initial line 2 format incorrect.",
        "void main(String[] args)", lines[19]);
    assertEquals("Initial line 3 format incorrect.",
        "throws Exception", lines[20]);

    Eclim.execute(new String[]{
      "java_format", "-p", Jdt.TEST_PROJECT,
      "-f", TEST_FILE,
      "-b", "0", "-e", "911"
    });

    contents = Eclim.fileToString(Jdt.TEST_PROJECT, TEST_FILE);
    lines = StringUtils.split(contents, '\n');
    assertEquals("Result line 1 format incorrect.",
        "\tpublic void main(String[] args) throws Exception {", lines[18]);
    assertEquals("Result line 1 format incorrect.",
        "\t\tSystem.out.println(\"test formatting\");", lines[19]);
  }
}
