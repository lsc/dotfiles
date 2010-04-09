.. Copyright (C) 2005 - 2009  Eric Van Dewoestine

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

.. _vim/common/vcs:

Version Control System Commands
===============================

Vcs Commands
------------

The following is a list of commands that may be execute when viewing a
file versioned in cvs, subversion, mercurial, or git (where applicable).

.. _\:VcsAnnotate:

- **:VcsAnnotate** -
  This command will run annotate / blame and visually annotate the current file
  via vim's sign support.  Due to vim limiting sign text to a maximum of two
  characters, the sign text will be the first two characters of the username.
  This command will also create a CursorHold event which will echo the version
  number and full author name for the current annotated line.

  Running this command on an already annotated file removes all annotations and
  disables the CursorHold event.

.. _\:VcsInfo:

- **:VcsInfo** -
  Echos vcs info about the currently versioned file.

.. _\:VcsLog:

- **:VcsLog** -
  Opens a buffer with log information for the current file. In this buffer
  you can perform various operations (diff, annotate, view log for another file,
  etc.) by hitting <Return> on any of the text links denoted by '\|link name\|'
  (ex.  '\|annotate\|').

  By default the number of entries retrieved will be limited to 50 in an effort
  to reduce the latency of retrieving logs for files with a long revision
  history.  This value can be changed via the :ref:`g:EclimVcsLogMaxEntries`
  variable.

.. _\:VcsChangeSet:

- **:VcsChangeSet** [revision] -
  Opens a buffer with change set information for the supplied repository
  version or the current revision of the currently open file. The special
  revision "prev" can be used to see the changeset of the previous repository
  version.

  Like **:VcsLog**, this buffer will contain text links which allow you to
  perform other operations.

.. _\:VcsDiff:

- **:VcsDiff** [revision] -
  Performs a vertical diffsplit of the current file against the last committed
  revision of the current file or the revision supplied. The special revision
  "prev" can be used to open a diff against the previous repository version.

.. _\:VcsCat:

- **:VcsCat** [revision] -
  Splits the current file with the contents of the last committed version of
  the current file or the supplied revision. The special revision "prev" can be
  used to view the file contents from the previous repository version.

.. _vcs-web:

Vcs Web Commands
----------------

The following list of commands are similar to those above, but instead of
opening a local buffer, these commands all open a url in the browser so that
you can use your favorite vcs web front end (viewvc, trac, etc.).

.. _\:VcsWebLog:

- **:VcsWebLog** -
  Opens the log for the currently versioned file in the configured vcs web app.

.. _\:VcsWebAnnotate:

- **:VcsWebAnnotate** [revision] -
  Opens the annotated view for the currently versioned file in the configured
  vcs web app.

.. _\:VcsWebChangeSet:

- **:VcsWebChangeSet** [revision] -
  Opens the change set for the currently versioned file in the configured vcs
  web app.

.. _\:VcsWebDiff:

- **:VcsWebDiff** [revision] -
  Opens a diff view for the currently versioned file in the configured in the
  configured vcs web app.


Configuration
--------------

Vim Settings

.. _g\:EclimVcsLogMaxEntries:

- **g:EclimVcsLogMaxEntries (Default: 50)** -
  When greater than 0, limits the number of log entries retrieved by
  **:VcsLog**.

.. _g\:EclimVcsDiffOrientation:

- **g:EclimVcsDiffOrientation (Default: 'vertical')** -
  When initiating diffs, this setting controls whether the diff window is
  opened as a horizontal split or vertical.  Supported values include
  'horizontal' and 'vertical'.

.. _g\:EclimVcsTrackerIdPatterns:

- **g:EclimVcsTrackerIdPatterns (Default: ['#\\(\\d\\+\\)'])** -
  Specifies a list of regular expression used to match tracker ids inside of
  vcs log comments.  Please note that the first group in each pattern must
  correspond to the tracker ticket id.  That portion of the match will be
  substituted into the '<id>' placeholder of the
  :ref:`tracker url <org.eclim.project.tracker>`.

Eclim Settings

.. _org.eclim.project.vcs.web.viewer:

- **org.eclim.project.vcs.web.viewer** -
  The web viewer to use. Possible values include\:

  - viewvc
  - trac
  - hgcgi
  - hgserve
  - gitweb
  - redmine

    .. note::

      Currenlty redmine is only partially supported with mercurial since
      redmine uses local revision numbers instead of the universal change set
      ids.

  Ex. An example using viewvc.

  ::

    org.eclim.project.vcs.web.viewer=viewvc

.. _org.eclim.project.vcs.web.url:

- **org.eclim.project.vcs.web.url** -
  Base url used for the chosen web viewer.

  Examples:

  ::

    # viewvc
    org.eclim.project.vcs.web.url=http://myhost/viewvc/myrepos/

    # hgcgi
    org.eclim.project.vcs.web.url=http://hg.myhost/myrepos

    # gitweb
    org.eclim.project.vcs.web.url=http://localhost:1234?p=.git

    # redmine
    # Note the literal <cmd> portion. Since redmine urls place the command name
    # (log, changes, etc) in front of the repository name, you must include the
    # <cmd> placeholder in your configured url so that the :VcsWeb commands can
    # replace it with the proper value.
    org.eclim.project.vcs.web.url=http://redmine.myhost/repositories/<cmd>/myrepos


.. _VcsEditor:

Vcs Editor Support
------------------

Subversion, mercurial, git, and cvs all support using vim as the default editor
for composing commit messages.  When composing this message they all also
include a list of files to be committed.  Eclim allows you to hit <enter> on
one of the files to view a diff of the version to be committed against the last
committed version, or in the case of newly added files, view the file to be
added.

.. image:: ../../images/screenshots/vcs/editor.png

.. note::

  **Git users:** Issuing a ``git commit`` from any directory other than the
  root of your working copy may lead to errors when attempting to view a diff
  or file in the editor.  This is due to git changing the working directory to
  the root but leaving the displayed file paths as relative, preventing eclim
  from being able to determine where those files reside.  To resolve this issue
  you will need to run the following to configure git to always display the
  full path (like mercurial does by default):

  ::

    $ git config --global status.relativePaths false
