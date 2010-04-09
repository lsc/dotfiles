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
package org.eclim.plugin.core.command.project;

import java.io.File;

import java.util.regex.Pattern;

import org.eclim.Eclim;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Tests the project commands.
 *
 * @author Eric Van Dewoestine
 */
public class ProjectCommandsTest
{
  private static final String TEST_PROJECT = "unit_test_create";
  private static final String TEST_PROJECT_IMPORT = "unit_test_import";
  private static final Pattern PROJECT_OPEN_PATTERN =
    Pattern.compile(TEST_PROJECT + "\\s+- open");

  @Test
  public void createProject()
  {
    // delete the test project if it exists
    if (Eclim.projectExists(TEST_PROJECT)){
      Eclim.execute(new String[]{"project_delete", "-p", TEST_PROJECT});
    }
    assertFalse("Project already exists.", Eclim.projectExists(TEST_PROJECT));

    String result = Eclim.execute(new String[]{
      "project_create",
      "-f", Eclim.getWorkspace() + "/" + TEST_PROJECT,
      "-n", "java"
    });
    System.out.println(result);

    assertTrue("Project not created.", Eclim.projectExists(TEST_PROJECT));
  }

  @Test
  public void closeProject()
  {
    assertTrue("Project not created.", Eclim.projectExists(TEST_PROJECT));

    String result = Eclim.execute(new String[]{
      "project_close", "-p", TEST_PROJECT});
    System.out.println(result);

    assertFalse("Project not closed.", projectOpen());
  }

  @Test
  public void openProject()
  {
    assertTrue("Project not created.", Eclim.projectExists(TEST_PROJECT));

    String result = Eclim.execute(new String[]{
      "project_open", "-p", TEST_PROJECT});
    System.out.println(result);

    assertTrue("Project not opened.", projectOpen());
  }

  @Test
  public void deleteProject()
  {
    assertTrue("Project not created.", Eclim.projectExists(TEST_PROJECT));

    String result = Eclim.execute(new String[]{
      "project_delete", "-p", TEST_PROJECT});
    System.out.println(result);

    assertFalse("Project not deleted.", Eclim.projectExists(TEST_PROJECT));

    // delete the project files + dir
    File dir = new File(Eclim.getWorkspace() + "/" + TEST_PROJECT);
    for(File f : dir.listFiles()){
      f.delete();
    }
    dir.delete();
  }

  @Test
  public void importProject()
  {
    // delete the test project if it exists
    if (Eclim.projectExists(TEST_PROJECT_IMPORT)){
      Eclim.execute(new String[]{"project_delete", "-p", TEST_PROJECT_IMPORT});
    }
    assertFalse("Project already exists.", Eclim.projectExists(TEST_PROJECT_IMPORT));

    // first create a project
    String result = Eclim.execute(new String[]{
      "project_create",
      "-f", Eclim.getWorkspace() + "/" + TEST_PROJECT_IMPORT,
      "-n", "java"
    });
    System.out.println(result);

    assertTrue("Project not created.", Eclim.projectExists(TEST_PROJECT_IMPORT));

    // then delete it
    result = Eclim.execute(new String[]{
      "project_delete", "-p", TEST_PROJECT_IMPORT});
    System.out.println(result);

    assertFalse("Project not deleted.", Eclim.projectExists(TEST_PROJECT_IMPORT));

    // now import it
    result = Eclim.execute(new String[]{
      "project_import", "-f", Eclim.getWorkspace() + "/" + TEST_PROJECT_IMPORT,
    });
    System.out.println(result);

    assertTrue("Project not imported.", Eclim.projectExists(TEST_PROJECT_IMPORT));

    result = Eclim.execute(new String[]{
      "project_natures", "-p", TEST_PROJECT_IMPORT,
    });
    System.out.println(result);
    assertEquals("Project missing java nature.", result,
        TEST_PROJECT_IMPORT + " - java");

    // delete the project and the project files + dir
    Eclim.execute(new String[]{"project_delete", "-p", TEST_PROJECT_IMPORT});
    File dir = new File(Eclim.getWorkspace() + "/" + TEST_PROJECT_IMPORT);
    for(File f : dir.listFiles()){
      f.delete();
    }
    dir.delete();
  }

  /**
   * Determines if the unit test project is open.
   *
   * @return true if the project is open, false otherwise.
   */
  private boolean projectOpen()
  {
    String list = Eclim.execute(new String[]{"project_list"});

    return PROJECT_OPEN_PATTERN.matcher(list).find();
  }
}
