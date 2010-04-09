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
package org.eclim.installer.step;

import java.awt.Component;

import java.io.File;
import java.io.FileInputStream;

import java.util.ArrayList;
import java.util.Properties;

import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.ListSelectionModel;

import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import foxtrot.Task;
import foxtrot.Worker;

import net.miginfocom.swing.MigLayout;

import org.apache.commons.io.IOUtils;

import org.apache.commons.lang.StringUtils;

import org.apache.tools.ant.BuildException;

import org.apache.tools.ant.taskdefs.Delete;

import org.apache.tools.ant.taskdefs.condition.Os;

import org.apache.tools.ant.types.FileSet;

import org.formic.InstallContext;
import org.formic.Installer;

import org.formic.util.CommandExecutor;

import org.formic.util.dialog.gui.GuiDialogs;

import org.formic.wizard.form.GuiForm;

import org.formic.wizard.form.gui.component.FileChooser;

import org.formic.wizard.form.validator.ValidatorBuilder;

import org.formic.wizard.step.AbstractGuiStep;

/**
 * Step for choosing the vimfiles directory to install vim scripts in.
 *
 * @author Eric Van Dewoestine
 */
public class VimStep
  extends AbstractGuiStep
{
  private static final String[] WINDOWS_VIMS = {
    "C:/Program Files/Vim/vim72/vim.exe",
    "C:/Program Files/Vim/vim72/gvim.exe",
    "C:/Program Files/Vim/vim71/vim.exe",
    "C:/Program Files/Vim/vim71/gvim.exe",
    "C:/Program Files/Vim/vim70/vim.exe",
    "C:/Program Files/Vim/vim70/gvim.exe",
  };

  private static final String[] WINDOWS_GVIMS = {
    "C:/Program Files/Vim/vim72/gvim.exe",
    "C:/Program Files/Vim/vim71/gvim.exe",
    "C:/Program Files/Vim/vim70/gvim.exe",
  };

  private static final String[] UNIX_VIMS = {"vim", "gvim"};

  private static final String COMMAND =
    "redir! > <file> | silent! echo &rtp | quit";

  private JPanel panel;
  private FileChooser fileChooser;
  private boolean rtpAttempted;
  private boolean homeVimCreatePrompted;
  private String[] runtimePath;

  /**
   * Constructs the step.
   */
  public VimStep (String name, Properties properties)
  {
    super(name, properties);
  }

  /**
   * {@inheritDoc}
   * @see org.formic.wizard.step.GuiStep#init()
   */
  public Component init ()
  {
    GuiForm form = createForm();
    String files = fieldName("files");
    fileChooser = new FileChooser(JFileChooser.DIRECTORIES_ONLY);

    panel = new JPanel(new MigLayout(
          "wrap 2", "[fill]", "[] [] [fill, grow]"));
    panel.add(form.createMessagePanel(), "span");
    panel.add(new JLabel(Installer.getString(files)), "split");
    panel.add(fileChooser, "skip");

    form.bind(files,
        fileChooser.getTextField(),
        new ValidatorBuilder()
          .required()
          .isDirectory()
          .fileExists()
          .isWritable()
          .validator());

    return panel;
  }

  /**
   * {@inheritDoc}
   * @see org.formic.wizard.WizardStep#displayed()
   */
  public void displayed ()
  {
    if(!rtpAttempted){
      rtpAttempted = true;

      setBusy(true);
      try{
        runtimePath = (String[])Worker.post(new Task(){
          public Object run () throws Exception {
            setGvimProperty();
            return getVimRuntimePath();
          }
        });

        // filter out dirs the user doesn't have permission write to.
        ArrayList filtered = new ArrayList();
        for (int ii = 0; ii < runtimePath.length; ii++){
          if (new File(runtimePath[ii]).canWrite()){
            filtered.add(runtimePath[ii]);
          }
        }
        String[] rtp = (String[])filtered.toArray(new String[filtered.size()]);

        if(rtp == null || rtp.length == 0){
          if(!homeVimCreatePrompted){
            createUserVimFiles("No suitable vim files directory found.");
          }else{
            GuiDialogs.showWarning(
                "Your vim install is still reporting no\n" +
                "suitable vim files directories.\n" +
                "You will need to manually specify one.");
          }
        }else{
          if(rtp.length == 1){
            fileChooser.getTextField().setText(rtp[0]);

            // try to discourage windows users from installing eclim files in
            // their vim installation.
            if(new File(rtp[0] + "/gvim.exe").exists()){
              createUserVimFiles("No user vim files directory found.");
            }
          }else{
            final JList list = new JList(rtp);
            list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
            JScrollPane scrollPane = new JScrollPane(list);
            panel.add(scrollPane, "span, grow");

            list.addListSelectionListener(new ListSelectionListener(){
              public void valueChanged (ListSelectionEvent event){
                if(!event.getValueIsAdjusting()){
                  fileChooser.getTextField()
                    .setText((String)list.getSelectedValue());
                }
              }
            });

            list.setSelectedIndex(0);
          }
        }
      }catch(Exception e){
        e.printStackTrace();
      }
      setBusy(false);
      fileChooser.getTextField().grabFocus();
    }
  }

  /**
   * {@inheritDoc}
   * @see org.formic.wizard.WizardStep#proceed()
   */
  public boolean proceed()
  {
    boolean proceed = super.proceed();
    if (proceed){
      InstallContext context = Installer.getContext();
      String vimfiles =
        ((String)context.getValue("vim.files")).replace('\\', '/');
      context.setValue("vim.files", vimfiles);

      // Check if the user has the eclim vim files already installed in another
      // directory in their vim's runtime path.

      // on windows, since case is insensitive, lower the path.
      if (Os.isFamily("windows")){
        vimfiles = vimfiles.toLowerCase();
      }

      if(runtimePath != null && runtimePath.length > 0){
        for (int ii = 0; ii < runtimePath.length; ii++){
          String rpath = runtimePath[ii];
          String path = rpath;
          if (Os.isFamily("windows")){
            path = path.toLowerCase();
          }
          if (vimfiles.equals(path)){
            continue;
          }

          File fpath = new File(path + "/plugin/eclim.vim");
          if (!fpath.exists()){
            continue;
          }

          if (fpath.canWrite()){
            boolean remove = GuiDialogs.showConfirm(
                "You appear to have one or more of the eclim vim files\n" +
                "installed in another directory:\n" +
                "  " + rpath + "\n" +
                "Would you like the installer to remove those files now?");
            if (remove){
              Delete delete = new Delete();
              delete.setProject(Installer.getProject());
              delete.setTaskName("delete");
              delete.setIncludeEmptyDirs(true);
              delete.setFailOnError(true);

              FileSet set = new FileSet();
              set.setDir(new File(path + "/eclim"));
              set.createInclude().setName("**/*");
              set.createExclude().setName("after/**/*");
              set.createExclude().setName("resources/**/*");
              delete.addFileset(set);

              try{
                boolean deleted = fpath.delete();
                if (!deleted){
                  throw new BuildException("Failed to delete file: plugin/eclim.vim");
                }
                delete.execute();
              }catch(BuildException be){
                GuiDialogs.showError(
                    "Failed to delete old eclim vim files:\n" +
                    "  " + be.getMessage() + "\n" +
                    "You may continue with the installation, but if old eclim\n" +
                    "vim files remain, chances are that you will receive\n" +
                    "errors upon starting (g)vim and the older version of\n" +
                    "the files may take precedence over the ones you are\n" +
                    "installing now, leading to indeterminate behavior.");
              }
            }
            proceed = remove;
          }else{
            GuiDialogs.showWarning(
                "You appear to have one or more of the eclim vim files\n" +
                "installed in another directory:\n" +
                "  " + rpath + "\n" +
                "Unfortunately it seems you do not have write access to\n" +
                "that directory. You may continue with the installation,\n" +
                "but chances are that you will receive errors upon starting\n" +
                "(g)vim and the older version of the files may take precedence\n" +
                "over the ones you are installing now, leading to indeterminate\n" +
                "behavior.");
          }
        }
      }
    }
    return proceed;
  }

  /**
   * Attempt to find where gvim is installed.
   */
  private void setGvimProperty ()
  {
    try{
      String[] gvims = null;
      if(Os.isFamily("windows")){
        gvims = WINDOWS_GVIMS;
        for (int ii = 0; ii < gvims.length; ii++){
          if (new File(gvims[ii]).isFile()){
            Installer.getProject().setProperty("eclim.gvim", gvims[ii]);
            break;
          }
        }
      }else{
        CommandExecutor executor =
          CommandExecutor.execute(new String[]{"which", "gvim"}, 1000);
        if(executor.getReturnCode() == 0){
          Installer.getProject().setProperty(
              "eclim.gvim", executor.getResult().trim());
        }
      }
    }catch(Exception e){
      e.printStackTrace();
    }
  }

  /**
   * Prompt the user to create the standard user local vim files directory.
   *
   * @param message The message indicating the primary reason we're asking them
   * if they want to create the user local directory.
   */
  private void createUserVimFiles(String message)
  {
    homeVimCreatePrompted = true;
    File vimfiles = new File(
        System.getProperty("user.home") + '/' +
        (Os.isFamily("windows") ? "vimfiles" : ".vim"));
    System.out.println(
        "Checking for user vim files directory: " + vimfiles);
    if(!vimfiles.exists()){
      boolean create = GuiDialogs.showConfirm(
          message + "\n" +
          "Would you like to create the standard\n" +
          "directory for your system?\n" +
          vimfiles);
      if(create){
        boolean created = vimfiles.mkdir();
        if(created){
          rtpAttempted = false;
          displayed();
        }else{
          GuiDialogs.showError("Unable to create directory: " + vimfiles);
        }
      }
    }else{
      fileChooser.getTextField().setText(
          vimfiles.getAbsolutePath().replace('\\', '/'));
    }
  }

  /**
   * Attempts to determine available paths in vim's runtime path.
   *
   * @return Array of paths or null if unable to determine any.
   */
  private String[] getVimRuntimePath ()
  {
    try{
      File tempFile = File.createTempFile("eclim_installer", null);
      String command = COMMAND.replaceFirst("<file>",
          tempFile.getAbsolutePath().replace('\\', '/').replaceAll(" ", "\\ "));

      String[] vims = null;
      if(Os.isFamily("windows")){
        vims = WINDOWS_VIMS;
      }else{
        vims = UNIX_VIMS;
      }

      String[] args = {null, "-f", "-X", "-u", "NONE", "-U", "NONE", "--cmd", command};
      for (int ii = 0; ii < vims.length; ii++){
        args[0] = vims[ii];
        CommandExecutor executor = CommandExecutor.execute(args, 5000);
        if(executor.getReturnCode() == 0){
          return parseVimRuntimePathResults(tempFile);
        }
        executor.destroy();
      }
    }catch(Exception e){
      e.printStackTrace();
    }

    return null;
  }

  /**
   * Parses the results of echoing vim runtime path to a file.
   *
   * @param file The file containing the results.
   * @return The results.
   */
  private String[] parseVimRuntimePathResults (File file)
  {
    FileInputStream in = null;
    try{
      String contents = IOUtils.toString(in = new FileInputStream(file));
      String[] paths = StringUtils.stripAll(StringUtils.split(contents, ','));
      ArrayList results = new ArrayList();
      for (int ii = 0; ii < paths.length; ii++){
        File path = new File(paths[ii]);
        if(path.isDirectory()){
          results.add(paths[ii].replace('\\', '/'));
        }
      }
      return (String[])results.toArray(new String[results.size()]);
    }catch(Exception e){
      e.printStackTrace();
    }finally{
      IOUtils.closeQuietly(in);
      file.deleteOnExit();
      file.delete();
    }
    return null;
  }
}
