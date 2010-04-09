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
package org.eclim.plugin.jdt.util;

import org.eclim.logging.Logger;

import org.eclipse.jdt.core.ICompilationUnit;
import org.eclipse.jdt.core.IJavaElement;

import org.eclipse.jdt.core.dom.AbstractTypeDeclaration;
import org.eclipse.jdt.core.dom.AST;
import org.eclipse.jdt.core.dom.ASTNode;
import org.eclipse.jdt.core.dom.ASTParser;
import org.eclipse.jdt.core.dom.CompilationUnit;
import org.eclipse.jdt.core.dom.FieldDeclaration;
import org.eclipse.jdt.core.dom.ImportDeclaration;
import org.eclipse.jdt.core.dom.Initializer;
import org.eclipse.jdt.core.dom.MethodDeclaration;
import org.eclipse.jdt.core.dom.PackageDeclaration;

import org.eclipse.jdt.internal.corext.dom.NodeFinder;

import org.eclipse.jface.text.Document;

import org.eclipse.text.edits.TextEdit;

/**
 * Utility class for working with the eclipse java dom model.
 *
 * @author Eric Van Dewoestine
 */
public class ASTUtils
{
  private static final Logger logger = Logger.getLogger(ASTUtils.class);

  private ASTUtils ()
  {
  }

  /**
   * Gets the AST CompilationUnit for the supplied ICompilationUnit.
   * <p/>
   * Equivalent of getCompilationUnit(src, false).
   *
   * @param src The ICompilationUnit.
   * @return The CompilationUnit.
   */
  public static CompilationUnit getCompilationUnit(ICompilationUnit src)
    throws Exception
  {
    return getCompilationUnit(src, false);
  }

  /**
   * Gets the AST CompilationUnit for the supplied ICompilationUnit.
   *
   * @param src The ICompilationUnit.
   * @param recordModifications true to record any modifications, false
   * otherwise.
   * @return The CompilationUnit.
   */
  public static CompilationUnit getCompilationUnit(
      ICompilationUnit src, boolean recordModifications)
    throws Exception
  {
    ASTParser parser = ASTParser.newParser(AST.JLS3);
    parser.setSource(src);
    CompilationUnit cu = (CompilationUnit)parser.createAST(null);
    if(recordModifications){
      cu.recordModifications();
    }

    return cu;
  }

  /**
   * Commits any changes made to the supplied CompilationUnit.
   * <p/>
   * Note: The method expects that the CompilationUnit is recording the
   * modifications (getCompilationUnit(src, true) was used).
   *
   * @param src The original ICompilationUnit.
   * @param node The CompilationUnit ast node.
   */
  public static void commitCompilationUnit(
      ICompilationUnit src, CompilationUnit node)
    throws Exception
  {
    Document document = new Document(src.getBuffer().getContents());
    TextEdit edits = node.rewrite(
        document, src.getJavaProject().getOptions(true));
    edits.apply(document);
    src.getBuffer().setContents(document.get());
    src.save(null, false);
  }

  /**
   * Finds the node at the specified offset.
   *
   * @param cu The CompilationUnit.
   * @param offset The node offset in the compilation unit.
   * @return The node at the specified offset.
   */
  public static ASTNode findNode(CompilationUnit cu, int offset)
    throws Exception
  {
    NodeFinder finder = new NodeFinder(offset, 1);
    cu.accept(finder);
    //return finder.getCoveredNode();
    return finder.getCoveringNode();
  }

  /**
   * Finds the node at the specified offset that matches up with the supplied
   * IJavaElement.
   *
   * @param cu The CompilationUnit.
   * @param offset The node offset in the compilation unit.
   * @param element The IJavaElement to match.
   * @return The node at the specified offset.
   */
  public static ASTNode findNode(
      CompilationUnit cu, int offset, IJavaElement element)
    throws Exception
  {
    ASTNode node = findNode(cu, offset);
    if(node == null){
      return null;
    }

    if(element.getElementType() == IJavaElement.TYPE_PARAMETER){
      element = element.getParent();
    }

    switch(element.getElementType()){
      case IJavaElement.PACKAGE_DECLARATION:
        node = resolveNode(node, PackageDeclaration.class);
        break;
      case IJavaElement.IMPORT_DECLARATION:
        node = resolveNode(node, ImportDeclaration.class);
        break;
      case IJavaElement.TYPE:
        node = resolveNode(node, AbstractTypeDeclaration.class);
        break;
      case IJavaElement.INITIALIZER:
        node = resolveNode(node, Initializer.class);
        break;
      case IJavaElement.FIELD:
        node = resolveNode(node, FieldDeclaration.class);
        break;
      case IJavaElement.METHOD:
        node = resolveNode(node, MethodDeclaration.class);
        break;
      default:
        logger.info("findNode(CompilationUnit,int,IJavaElement) - " +
            "unrecognized element type " + element.getElementType());
    }
    return node;
  }

  /**
   * Walk up the node tree until a node of the specified type is reached.
   *
   * @param node The starting node.
   * @param type The type to resolve.
   * @return The resulting node.
   */
  private static ASTNode resolveNode(ASTNode node, Class type)
    throws Exception
  {
    if(node == null){
      return null;
    }

    if(type.isAssignableFrom(node.getClass())){
      return node;
    }

    return resolveNode(node.getParent(), type);
  }
}
