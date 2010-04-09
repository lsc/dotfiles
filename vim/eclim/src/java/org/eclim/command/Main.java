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
package org.eclim.command;

import java.util.ArrayList;
import java.util.Arrays;

import org.apache.commons.cli.ParseException;

import org.apache.commons.lang.StringUtils;

import org.eclim.Services;

import org.eclim.eclipse.AbstractEclimApplication;

import org.eclim.logging.Logger;

import org.eclipse.swt.widgets.EclimDisplay;

/**
 * Entry point for client invocation.
 *
 * @author Eric Van Dewoestine
 */
public class Main
{
  private static final Logger logger = Logger.getLogger(Main.class);

  /**
   * Main method for executing the client.
   *
   * @param args The command line args.
   */
  public static final void main(String[] args)
  {
    try{
      logger.debug("args: " + Arrays.toString(args));

      if (!AbstractEclimApplication.getInstance().isHeaded()){
        // set dummy display's current thread
        ((EclimDisplay)org.eclipse.swt.widgets.Display.getDefault())
          .setThread(Thread.currentThread());
      }

      ArrayList<String> arguments = new ArrayList<String>();
      for(String arg : args){
        if(arg.startsWith("-D")){
          String[] prop = StringUtils.split(arg.substring(2), '=');
          System.setProperty(prop[0], prop[1]);
        }else{
          arguments.add(arg);
        }
      }

      CommandLine commandLine = null;
      Options options = new Options();
      try{
        commandLine = options.parse(
            (String[])arguments.toArray(new String[arguments.size()]));
      }catch(ParseException e){
        System.out.println(
            Services.getMessage(e.getClass().getName(), e.getMessage()));
        logger.debug("Main - exit on error");
        System.exit(1);
      }

      String commandName = commandLine.getValue(Options.COMMAND_OPTION);
      logger.debug("Main - command: {}", commandName);
      if(commandName == null || commandName.trim().equals(StringUtils.EMPTY)){
        throw new IllegalArgumentException(
            Services.getMessage("command.required"));
      }
      Command command = commandLine.getCommand();

      String result = command.execute(commandLine);
      System.out.println(result);
    }catch(Exception e){
      logger.debug("Command triggered exception: " + Arrays.toString(args), e);
      e.printStackTrace();

      logger.debug("Main - exit on error");
      System.exit(1);
    }
  }
}
