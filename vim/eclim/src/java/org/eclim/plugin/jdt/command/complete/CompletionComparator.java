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
package org.eclim.plugin.jdt.command.complete;

import java.text.Collator;

import java.util.Comparator;
import java.util.Locale;

import org.eclipse.jdt.core.CompletionProposal;

/**
 * Comparator for sorting completion results.
 *
 * @author Eric Van Dewoestine
 */
public class CompletionComparator
  implements Comparator<CodeCompleteResult>
{
  /**
   * {@inheritDoc}
   */
  public int compare(CodeCompleteResult o1, CodeCompleteResult o2)
  {
    if(o1 == null && o2 == null){
      return 0;
    }else if(o2 == null){
      return -1;
    }else if(o1 == null){
      return 1;
    }

    // push keywords to the end.
    if (o1.getType() != CompletionProposal.KEYWORD &&
        o2.getType() != CompletionProposal.KEYWORD){
      int kind = o1.getType() - o2.getType();
      if(kind != 0){
        return kind;
      }
    }else if(o1.getType() == CompletionProposal.KEYWORD &&
        o2.getType() != CompletionProposal.KEYWORD){
      return 1;
    }else if(o2.getType() == CompletionProposal.KEYWORD &&
        o1.getType() != CompletionProposal.KEYWORD){
      return -1;
    }

    return Collator.getInstance(Locale.US).compare(
        new String(o1.getCompletion()), new String(o2.getCompletion()));
  }

  /**
   * {@inheritDoc}
   */
  public boolean equals(Object obj)
  {
    if(obj instanceof CompletionComparator){
      return true;
    }
    return false;
  }
}
