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
package org.eclim.plugin.jdt.project;

import java.io.FileInputStream;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import org.eclim.Services;

import org.eclim.command.CommandLine;
import org.eclim.command.Error;
import org.eclim.command.Options;

import org.eclim.plugin.jdt.PluginResources;

import org.eclim.plugin.jdt.project.classpath.Dependency;
import org.eclim.plugin.jdt.project.classpath.IvyParser;
import org.eclim.plugin.jdt.project.classpath.Parser;

import org.eclim.plugin.jdt.util.JavaUtils;

import org.eclim.plugin.core.project.ProjectManager;

import org.eclim.plugin.core.util.ProjectUtils;
import org.eclim.plugin.core.util.XmlUtils;

import org.eclim.util.IOUtils;

import org.eclim.util.file.FileOffsets;
import org.eclim.util.file.FileUtils;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IWorkspaceRoot;

import org.eclipse.core.runtime.Path;

import org.eclipse.jdt.core.IClasspathAttribute;
import org.eclipse.jdt.core.IClasspathEntry;
import org.eclipse.jdt.core.IJavaModelStatus;
import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.core.JavaConventions;
import org.eclipse.jdt.core.JavaCore;

import org.eclipse.jdt.internal.ui.wizards.ClassPathDetector;

import org.eclipse.jdt.launching.JavaRuntime;

/**
 * Implementation of {@link ProjectManager} for java projects.
 *
 * @author Eric Van Dewoestine
 */
public class JavaProjectManager
  implements ProjectManager
{
  private static final String PRESERVE = "eclim.preserve";

  private static final String CLASSPATH = ".classpath";
  private static final String CLASSPATH_XSD =
    "/resources/schema/eclipse/classpath.xsd";

  private static final HashMap<String, Parser> PARSERS =
    new HashMap<String, Parser>();
  static{
    PARSERS.put("ivy.xml", new IvyParser());
  }

  /**
   * {@inheritDoc}
   */
  public void create(IProject project, CommandLine commandLine)
    throws Exception
  {
    String depends = commandLine.getValue(Options.DEPENDS_OPTION);
    create(project, depends);
  }

  /**
   * {@inheritDoc}
   */
  public List<Error> update(IProject project, CommandLine commandLine)
    throws Exception
  {
    String buildfile = commandLine.getValue(Options.BUILD_FILE_OPTION);

    IJavaProject javaProject = JavaUtils.getJavaProject(project);
    javaProject.getResource().refreshLocal(IResource.DEPTH_INFINITE, null);

    // validate that .classpath xml is well formed and valid.
    PluginResources resources = (PluginResources)
      Services.getPluginResources(PluginResources.NAME);
    List<Error> errors = XmlUtils.validateXml(
        javaProject.getProject().getName(),
        CLASSPATH,
        resources.getResource(CLASSPATH_XSD).toString());
    if(errors.size() > 0){
      return errors;
    }

    String dotclasspath = javaProject.getProject().getFile(CLASSPATH)
      .getRawLocation().toOSString();

    // ivy.xml, etc updated.
    if(buildfile != null){
      String filename = FileUtils.getBaseName(buildfile);
      Parser parser = PARSERS.get(filename);
      IClasspathEntry[] entries = merge(javaProject, parser.parse(buildfile));
      errors = setClasspath(javaProject, entries, dotclasspath);

    // .classpath updated.
    }else{
      IClasspathEntry[] entries = javaProject.readRawClasspath();
      errors = setClasspath(javaProject, entries, dotclasspath);
    }

    if(errors.size() > 0){
      return errors;
    }
    return null;
  }

  /**
   * {@inheritDoc}
   */
  public void refresh(IProject project, CommandLine commandLine)
    throws Exception
  {
  }

  /**
   * {@inheritDoc}
   */
  public void delete(IProject project, CommandLine commandLine)
    throws Exception
  {
  }

// Project creation methods

  /**
   * Creates a new project.
   *
   * @param project The project.
   * @param dependsString Comma seperated project names this project depends on.
   */
  protected void create(IProject project, String dependsString)
    throws Exception
  {
    IJavaProject javaProject = JavaCore.create(project);

    if (!project.getFile(CLASSPATH).exists()) {
      ClassPathDetector detector = new ClassPathDetector(project, null);
      IClasspathEntry[] detected = detector.getClasspath();
      IClasspathEntry[] depends =
        createOrUpdateDependencies(javaProject, dependsString);
      IClasspathEntry[] container = new IClasspathEntry[]{
        JavaCore.newContainerEntry(new Path(JavaRuntime.JRE_CONTAINER))
      };

      IClasspathEntry[] classpath = merge(
          new IClasspathEntry[][]{detected, depends, container});
            //javaProject.readRawClasspath(), detected, depends, container

      javaProject.setRawClasspath(classpath, null);
    }
    javaProject.makeConsistent(null);
    javaProject.save(null, false);
  }

  /**
   * Creates or updates the projects dependencies on other projects.
   *
   * @param project The project.
   * @param depends The comma seperated list of project names.
   */
  protected IClasspathEntry[] createOrUpdateDependencies(
      IJavaProject project, String depends)
    throws Exception
  {
    if(depends != null){
      String[] dependPaths = StringUtils.split(depends, ',');
      IClasspathEntry[] entries = new IClasspathEntry[dependPaths.length];
      for(int ii = 0; ii < dependPaths.length; ii++){
        IProject theProject = ProjectUtils.getProject(dependPaths[ii]);
        if(!theProject.exists()){
          throw new IllegalArgumentException(Services.getMessage(
              "project.depends.not.found", dependPaths[ii]));
        }
        IJavaProject otherProject = JavaCore.create(theProject);
        entries[ii] = JavaCore.newProjectEntry(otherProject.getPath(), true);
      }
      return entries;
    }
    return new IClasspathEntry[0];
  }

  /**
   * Merges the supplied classpath entries into one.
   *
   * @param entries The array of classpath entry arrays to merge.
   *
   * @return The union of all entry arrays.
   */
  protected IClasspathEntry[] merge(IClasspathEntry[][] entries)
  {
    ArrayList<IClasspathEntry> union = new ArrayList<IClasspathEntry>();
    if(entries != null){
      for(IClasspathEntry[] values : entries){
        if(values != null){
          for(IClasspathEntry entry : values){
            if(!union.contains(entry)){
             union.add(entry);
            }
          }
        }
      }
    }
    return (IClasspathEntry[])union.toArray(new IClasspathEntry[union.size()]);
  }

// Project update methods

  /**
   * Sets the classpath for the supplied project.
   *
   * @param javaProject The project.
   * @param entries The classpath entries.
   * @param classpath The file path of the .classpath file.
   * @return Array of Error or null if no errors reported.
   */
  protected List<Error> setClasspath(
      IJavaProject javaProject, IClasspathEntry[] entries, String classpath)
    throws Exception
  {
    FileOffsets offsets = FileOffsets.compile(classpath);
    String classpathValue = IOUtils.toString(new FileInputStream(classpath));
    ArrayList<Error> errors = new ArrayList<Error>();
    for(IClasspathEntry entry : entries){
      IJavaModelStatus status = JavaConventions
        .validateClasspathEntry(javaProject, entry, true);
      if(!status.isOK()){
        errors.add(createErrorForEntry(
              javaProject, entry, status, offsets, classpath, classpathValue));
      }
    }

    IJavaModelStatus status = JavaConventions.validateClasspath(
        javaProject, entries, javaProject.getOutputLocation());

    // always set the classpathValue anyways, so that the user can correct the
    // file.
    //if(status.isOK() && errors.isEmpty()){
      javaProject.setRawClasspath(entries, null);
      javaProject.makeConsistent(null);
    //}

    if(!status.isOK()){
      errors.add(new Error(status.getMessage(), classpath, 1, 1, false));
    }
    return errors;
  }

  /**
   * Creates an Error from the supplied IJavaModelStatus.
   *
   * @param project The java project.
   * @param entry The classpath entry.
   * @param status The IJavaModelStatus.
   * @param offsets File offsets for the classpath file.
   * @param filename The filename of the error.
   * @param contents The contents of the file as a String.
   * @return The Error.
   */
  protected Error createErrorForEntry(
      IJavaProject project,
      IClasspathEntry entry,
      IJavaModelStatus status,
      FileOffsets offsets,
      String filename,
      String contents)
    throws Exception
  {
    int line = 0;
    int col = 0;

    String path = entry.getPath().toOSString();
    path = path.replaceFirst("^/" + project.getProject().getName() + "/", "");
    Matcher matcher =
      Pattern.compile("path\\s*=(['\"])\\s*\\Q" + path + "\\E\\s*\\1")
        .matcher(contents);
    if(matcher.find()){
      int[] position = offsets.offsetToLineColumn(matcher.start());
      line = position[0];
      col = position[1];
    }

    return new Error(status.getMessage(), filename, line, col, false);
  }

  /**
   * Merges the supplied project's classpath with the specified dependencies.
   *
   * @param project The project.
   * @param dependencies The dependencies.
   * @return The classpath entries.
   */
  protected IClasspathEntry[] merge(
      IJavaProject project, Dependency[] dependencies)
    throws Exception
  {
    IWorkspaceRoot root = project.getProject().getWorkspace().getRoot();
    ArrayList<IClasspathEntry> results = new ArrayList<IClasspathEntry>();

    // load the results with all the non library entries.
    IClasspathEntry[] entries = project.getRawClasspath();
    for(int ii = 0; ii < entries.length; ii++){
      if (entries[ii].getEntryKind() != IClasspathEntry.CPE_LIBRARY &&
          entries[ii].getEntryKind() != IClasspathEntry.CPE_VARIABLE){
        results.add(entries[ii]);
      } else if (preserve(entries[ii])){
        results.add(entries[ii]);
      }
    }

    // merge the dependencies with the classpath entires.
    for(int ii = 0; ii < dependencies.length; ii++){
      IClasspathEntry match = null;
      for(int jj = 0; jj < entries.length; jj++){
        if (entries[jj].getEntryKind() == IClasspathEntry.CPE_LIBRARY ||
            entries[jj].getEntryKind() == IClasspathEntry.CPE_VARIABLE){
          String path = entries[jj].getPath().toOSString();
          String pattern = dependencies[ii].getName() +
            Dependency.VERSION_SEPARATOR;

          // exact match
          if(path.endsWith(dependencies[ii].toString())){
            match = entries[jj];
            results.add(entries[jj]);
            break;

          // different version match
          }else if(path.indexOf(pattern) != -1){
            break;
          }
        }else if(entries[jj].getEntryKind() == IClasspathEntry.CPE_PROJECT){
          String path = entries[jj].getPath().toOSString();
          if(path.endsWith(dependencies[ii].getName())){
            match = entries[jj];
            break;
          }
        }
      }

      if(match == null){
        IClasspathEntry entry = createEntry(root, project, dependencies[ii]);
        results.add(entry);
      }else{
        match = null;
      }
    }

    return (IClasspathEntry[])
      results.toArray(new IClasspathEntry[results.size()]);
  }

  /**
   * Determines if the supplied entry contains attribute indicating that it
   * should not be removed.
   *
   * @param entry The IClasspathEntry
   * @return true to preserve the entry, false otherwise.
   */
  protected boolean preserve(IClasspathEntry entry)
  {
    IClasspathAttribute[] attributes = entry.getExtraAttributes();
    for(int ii = 0; ii < attributes.length; ii++){
      String name = attributes[ii].getName();
      if(PRESERVE.equals(name)){
        return Boolean.parseBoolean(attributes[ii].getValue());
      }
    }
    return false;
  }

  /**
   * Creates the classpath entry.
   *
   * @param root The workspace root.
   * @param project The project to create the dependency in.
   * @param dependency The dependency to create the entry for.
   * @return The classpath entry.
   */
  protected IClasspathEntry createEntry(
      IWorkspaceRoot root, IJavaProject project, Dependency dependency)
    throws Exception
  {
    if(dependency.isVariable()){
      return JavaCore.newVariableEntry(dependency.getPath(), null, null, true);
    }

    return JavaCore.newLibraryEntry(dependency.getPath(), null, null, true);
  }

  /**
   * Determines if the supplied path starts with a variable name.
   *
   * @param path The path to test.
   * @return True if the path starts with a variable name, false otherwise.
   */
  protected boolean startsWithVariable(String path)
  {
    String[] variables = JavaCore.getClasspathVariableNames();
    for(int ii = 0; ii < variables.length; ii++){
      if(path.startsWith(variables[ii])){
        return true;
      }
    }
    return false;
  }
}
