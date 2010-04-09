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
package org.vimplugin.editors;

import org.eclim.logging.Logger;

import org.eclipse.core.commands.CommandManager;

import org.eclipse.core.commands.contexts.ContextManager;

import org.eclipse.jface.bindings.Binding;
import org.eclipse.jface.bindings.BindingManager;
import org.eclipse.jface.bindings.Scheme;

import org.eclipse.jface.bindings.keys.KeyBinding;
import org.eclipse.jface.bindings.keys.KeySequence;
import org.eclipse.jface.bindings.keys.ParseException;

import org.eclipse.ui.IPartListener;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.PlatformUI;

import org.eclipse.ui.internal.keys.KeySequenceBinding;

import org.eclipse.ui.keys.IBindingService;

/**
 * Listener responsible to disabling/enabling certain eclipse features as vim
 * editors gain and lose focus.
 *
 * Key binding manipulation gleaned from:
 *   org.eclipse.ui.internal.keys.KeysPreferencePage
 *
 * @author Eric Van Dewoestine
 */
public class VimEditorPartListener
  implements IPartListener
{
  private static final Logger logger =
    Logger.getLogger(VimEditorPartListener.class);

    // "In Windows"
  private static final String CONTEXT_ID =
    KeySequenceBinding.DEFAULT_CONTEXT_ID;

    // "Default"
  private static final String SCHEME_ID =
    IBindingService.DEFAULT_DEFAULT_ACTIVE_SCHEME_ID;

  private boolean keysDisabled = false;
  private IBindingService bindingService;
  private final BindingManager localChangeManager =
    new BindingManager(new ContextManager(), new CommandManager());

  private String[] keys = {"Ctrl+U", "Ctrl+W"};

  private KeySequence[] keySequences;

  public VimEditorPartListener()
  {
    IWorkbench workbench = PlatformUI.getWorkbench();
    bindingService = (IBindingService)workbench.getService(IBindingService.class);

    Scheme scheme = bindingService.getScheme(
        IBindingService.DEFAULT_DEFAULT_ACTIVE_SCHEME_ID);
    try{
      localChangeManager.setActiveScheme(scheme);
      localChangeManager.setLocale(bindingService.getLocale());
      localChangeManager.setPlatform(bindingService.getPlatform());
      localChangeManager.setBindings(bindingService.getBindings());
    }catch(Exception e){
      logger.error("Error initializing local binding manager.", e);
    }

    keySequences = new KeySequence[keys.length];
    for (int ii = 0; ii < keys.length; ii++){
      try{
        keySequences[ii] = KeySequence.getInstance(keys[ii]);
      }catch(ParseException pe){
        logger.error("Unable to parse keybinding: " + keys[ii], pe);
      }
    }

    // get context ids
    /*IContextService contextService = (IContextService)
      workbench.getService(IContextService.class);
    try{
      for (java.util.Iterator iterator = contextService.getDefinedContextIds()
          .iterator(); iterator.hasNext();)
      {
        String id = (String) iterator.next();
        Context context = contextService.getContext(id);
        String name = context.getName();
        System.out.println("### id: " + id + " name: " + name);
      }
    }catch(Exception e){
      e.printStackTrace();
    }*/

    // get scheme ids
    /*Scheme[] definedSchemes = bindingService.getDefinedSchemes();
    try{
      for (int i = 0; i < definedSchemes.length; i++) {
        Scheme scheme = definedSchemes[i];
        String name = scheme.getName();
        String id = scheme.getId();
        System.out.println("### id: " + id + " name: " + name);
      }
    }catch(Exception e){
      e.printStackTrace();
        // Do nothing.
    }*/
  }

  /**
   * {@inheritDoc}
   * @see IPartListener#partActivated(IWorkbenchPart)
   */
  public void partActivated(IWorkbenchPart part)
  {
    if (part instanceof VimEditor){
      VimEditor editor = (VimEditor)part;
      if (editor.isEmbedded()){
        disableKeys();
      }
    }else{
      enableKeys();
    }
  }

  /**
   * {@inheritDoc}
   * @see IPartListener#partBroughtToTop(IWorkbenchPart)
   */
  public void partBroughtToTop(IWorkbenchPart part)
  {
  }

  /**
   * {@inheritDoc}
   * @see IPartListener#partClosed(IWorkbenchPart)
   */
  public void partClosed(IWorkbenchPart part)
  {
  }

  /**
   * {@inheritDoc}
   * @see IPartListener#partDeactivated(IWorkbenchPart)
   */
  public void partDeactivated(IWorkbenchPart part)
  {
  }

  /**
   * {@inheritDoc}
   * @see IPartListener#partOpened(IWorkbenchPart)
   */
  public void partOpened(IWorkbenchPart part)
  {
  }

  private void disableKeys()
  {
    if (!keysDisabled){
      logger.debug(
          "Disabling conflicting keybindings while vim editor is focused.");
      for(KeySequence keySequence : keySequences){
        localChangeManager.removeBindings(
            keySequence, SCHEME_ID, CONTEXT_ID, null, null, null, Binding.USER);
        localChangeManager.addBinding(new KeyBinding(
              keySequence, null, SCHEME_ID, CONTEXT_ID,
              null, null, null, Binding.USER));
      }
      keysDisabled = true;
      saveKeyChanges();
    }
  }

  private void enableKeys()
  {
    if (keysDisabled){
      logger.debug("Re-enabling conflicting keybindings.");
      for(KeySequence keySequence : keySequences){
        localChangeManager.removeBindings(
            keySequence, SCHEME_ID, CONTEXT_ID, null, null, null, Binding.USER);
      }
      keysDisabled = false;
      saveKeyChanges();
    }
  }

  private void saveKeyChanges()
  {
    try{
      bindingService.savePreferences(
          localChangeManager.getActiveScheme(),
          localChangeManager.getBindings());
    }catch(Exception e){
      logger.error("Error persisting key bindings.", e);
    }
  }
}
