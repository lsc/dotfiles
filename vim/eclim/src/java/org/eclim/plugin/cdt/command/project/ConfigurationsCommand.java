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
package org.eclim.plugin.cdt.command.project;

import org.eclim.annotation.Command;

import org.eclim.command.CommandLine;
import org.eclim.command.Options;

import org.eclim.plugin.core.command.AbstractCommand;

import org.eclim.plugin.core.util.ProjectUtils;

import org.eclim.util.StringUtils;

import org.eclipse.cdt.core.CCProjectNature;
import org.eclipse.cdt.core.CCorePlugin;
import org.eclipse.cdt.core.CProjectNature;

import org.eclipse.cdt.core.settings.model.ICConfigurationDescription;
import org.eclipse.cdt.core.settings.model.ICProjectDescription;
import org.eclipse.cdt.core.settings.model.ICSourceEntry;

import org.eclipse.cdt.managedbuilder.core.IConfiguration;
import org.eclipse.cdt.managedbuilder.core.IOption;
import org.eclipse.cdt.managedbuilder.core.ITool;
import org.eclipse.cdt.managedbuilder.core.ManagedBuildManager;

import org.eclipse.core.resources.IProject;

import org.eclipse.core.runtime.IPath;

/**
 * Command to obtain the current configuration (source entries, include
 * locations, etc.) for the specified project.
 *
 * @author Eric Van Dewoestine
 */
@Command(
  name = "c_project_configs",
  options = "REQUIRED p project ARG"
)
public class ConfigurationsCommand
  extends AbstractCommand
{
  /**
   * {@inheritDoc}
   * @see org.eclim.command.Command#execute(CommandLine)
   */
  public String execute(CommandLine commandLine)
    throws Exception
  {
    String projectName = commandLine.getValue(Options.PROJECT_OPTION);

    IProject project = ProjectUtils.getProject(projectName);
    ICProjectDescription desc =
      CCorePlugin.getDefault().getProjectDescription(project, false);
    ICConfigurationDescription[] cconfigs = desc.getConfigurations();

    StringBuffer out = new StringBuffer();
    for(ICConfigurationDescription cconfig : cconfigs){
      if (out.length() > 0){
        out.append('\n');
      }
      out.append("Config: ").append(cconfig.getName()).append('\n');

      // source entries
      ICSourceEntry[] sources = cconfig.getSourceEntries();
      if (sources.length > 0){
        out.append("\n\tSources: |add|\n");
        for(ICSourceEntry entry : sources){
          String dirname = entry.getFullPath().removeFirstSegments(1).toString();
          if (dirname.length() == 0){
            dirname = "/";
          }
          out.append("\t\tdir:    ")
            .append(dirname)
            .append('\n');
          IPath[] excludes = entry.getExclusionPatterns();
          if (excludes.length > 0){
            String[] patterns = new String[excludes.length];
            for (int ii = 0; ii < excludes.length; ii++){
              patterns[ii] = excludes[ii].toString();
            }
            out.append("\t\t\texcludes: ")
              .append(StringUtils.join(patterns, ','))
              .append('\n');
          }
        }
      }

      IConfiguration config =
        ManagedBuildManager.getConfigurationForDescription(cconfig);
      ITool[] tools = config.getTools();
      if(tools.length > 0){
        for(ITool tool : tools){
          if (!tool.isEnabled() || !acceptTool(project, tool)){
            continue;
          }

          IOption ioption = getOptionByType(tool, IOption.INCLUDE_PATH);
          IOption soption = getOptionByType(tool, IOption.PREPROCESSOR_SYMBOLS);
          if (ioption == null && soption == null){
            continue;
          }

          out.append("\n\tTool: ").append(tool.getName()).append('\n');

          // includes
          if(ioption != null){
            out.append("\t\tIncludes: |add|\n");
            String[] includes = ioption.getIncludePaths();
            if(includes.length > 0){
              for(String include : includes){
                out.append("\t\t\tpath:       ").append(include).append('\n');
              }
            }
          }

          // symbols
          if(soption != null){
            out.append("\t\tSymbols:  |add|\n");
            String[] symbols = soption.getDefinedSymbols();
            if(symbols.length > 0){
              for(String symbol : symbols){
                out.append("\t\t\tname/value: ").append(symbol).append('\n');
              }
            }
          }
        }
      }
    }

    return out.toString();
  }

  private boolean acceptTool(IProject project, ITool tool)
    throws Exception
  {
    switch (tool.getNatureFilter()) {
      case ITool.FILTER_C:
        if (project.hasNature(CProjectNature.C_NATURE_ID) &&
            !project.hasNature(CCProjectNature.CC_NATURE_ID))
        {
          return true;
        }
        break;
      case ITool.FILTER_CC:
        if (project.hasNature(CCProjectNature.CC_NATURE_ID)) {
          return true;
        }
        break;
      case ITool.FILTER_BOTH:
        return true;
    }
    return false;
  }

  private IOption getOptionByType(ITool tool, int type)
    throws Exception
  {
    IOption[] options = tool.getOptions();
    for(IOption option : options){
      if(option.getValueType() == type){
        return option;
      }
    }
    return null;
  }
}
