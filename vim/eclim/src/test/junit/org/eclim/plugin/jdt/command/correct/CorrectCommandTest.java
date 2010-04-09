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
package org.eclim.plugin.jdt.command.correct;

import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import org.eclim.Eclim;

import org.eclim.plugin.jdt.Jdt;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Test case for CorrectCommand.
 *
 * @author Eric Van Dewoestine
 */
public class CorrectCommandTest
{
  private static final String TEST_FILE =
    "src/org/eclim/test/correct/TestCorrect.java";

  private static final String TEST_FILE_PACKAGE =
    "src/org/eclim/test/correct/TestCorrectPackage.java";

  @Test
  public void suggest()
  {
    assertTrue("Java project doesn't exist.",
        Eclim.projectExists(Jdt.TEST_PROJECT));

    String result = Eclim.execute(new String[]{
      "java_correct", "-p", Jdt.TEST_PROJECT,
      "-f", TEST_FILE,
      "-l", "5", "-o", "74", "-e", "utf-8"
    });

    System.out.println(result);

    String[] results = StringUtils.split(result, '\n');

    assertEquals("Wrong error.",
        "ArrayList cannot be resolved to a type", results[0]);
    assertTrue("Wrong suggestion.",
        results[1].indexOf(".70:  Change to") != -1);
  }

  @Test
  public void apply()
  {
    assertTrue("Java project doesn't exist.",
        Eclim.projectExists(Jdt.TEST_PROJECT));

    String result = Eclim.execute(new String[]{
      "java_correct", "-p", Jdt.TEST_PROJECT,
      "-f", TEST_FILE,
      "-l", "5", "-o", "74", "-e", "utf-8"
    });

    System.out.println(result);

    String[] results = StringUtils.split(result, '\n');
    int apply = -1;
    for(String r : results){
      if (r.indexOf("Import 'ArrayList' (java.util)") != -1){
        apply = Integer.valueOf(r.substring(0, 1));
        break;
      }
    }
    assertTrue("Missing expected suggestion.", apply > -1);

    result = Eclim.execute(new String[]{
      "java_correct", "-p", Jdt.TEST_PROJECT,
      "-f", TEST_FILE,
      "-l", "5", "-o", "74", "-e", "utf-8", "-a", String.valueOf(apply)
    });

    System.out.println(result);

    assertTrue("Import not found.",
        Pattern.compile("import java\\.").matcher(result).find());
  }

  @Test
  public void suggestPackage()
  {
    assertTrue("Java project doesn't exist.",
        Eclim.projectExists(Jdt.TEST_PROJECT));

    String result = Eclim.execute(new String[]{
      "java_correct", "-p", Jdt.TEST_PROJECT,
      "-f", TEST_FILE_PACKAGE,
      "-l", "1", "-o", "0", "-e", "utf-8"
    });

    System.out.println(result);

    String[] results = StringUtils.split(result, '\n');

    assertEquals("Wrong error.",
        "The declared package \"org.test\" does not match the expected " +
        "package \"org.eclim.test.correct\"",
        results[0]);
    assertTrue("Wrong suggestion description.",
        results[1].indexOf("'org.eclim.test.correct'") != -1);
    assertTrue("Wrong suggestion preview.",
        results[3].indexOf("package org.eclim.test.correct;") != -1);
  }

  @Test
  public void applyPackage()
  {
    assertTrue("Java project doesn't exist.",
        Eclim.projectExists(Jdt.TEST_PROJECT));

    String result = Eclim.execute(new String[]{
      "java_correct", "-p", Jdt.TEST_PROJECT,
      "-f", TEST_FILE_PACKAGE,
      "-l", "1", "-o", "0", "-e", "utf-8", "-a", "0"
    });

    System.out.println(result);

    String[] results = StringUtils.split(result, '\n');
    assertEquals("Incorrect package", "package org.eclim.test.correct;", results[0]);
  }
}
