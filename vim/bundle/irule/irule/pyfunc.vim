"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pyfunc.vim, version 0.1.1. This file provides the main 
" functionality provided by the vim-iruler plugins.
" If you modify this, please share your work!
" Contributors: Matt Cauthorn, Jason Rahm
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Create a global var to toggle on init. Don't change this!!!
py create_rule = True

"Setup some global python stuff (global to a session

python << EOF
import vim
import os
from pycontrol.pycontrol import BIGIP

def get_objects(host,user,passwd):
    ''' Return a couple of pycontrol objects, one for LTM, the other GTM.'''
    try:
        b = BIGIP(hostname=host,username=user,password=passwd,fromurl=True,wsdls=['LocalLB.Rule','GlobalLB.Rule'])
        ltm = b.LocalLB.Rule
        gtm = b.GlobalLB.Rule
    except Exception, e:
        print e
    return (ltm, gtm)

def location(host):
    loc = 'https://%s/iControl/iControlPortal.cgi' % host
    ltm.suds.set_options(location=loc)
    gtm.suds.set_options(location=loc)

def get_name():
    ''' Returns the current rule name in the buffer, minus the extension '''
    buf = vim.current.buffer
    rule_name = os.path.basename(buf.name).replace('.irul','')
    return rule_name

def get_creds():
    ''' returns username and pass from the vim prompt'''
    vim.command('let USER = input("Username: ")')
    vim.command('let PASS = inputsecret("Password: ")')
    user = vim.eval("USER")
    passwd = vim.eval("PASS")
    return user,passwd

def login(host,user,passwd):
    loc = 'https://%s/iControl/iControlPortal.cgi' % host
    ltm.suds.set_options(location=loc,username=user,password=passwd)
    gtm.suds.set_options(location=loc,username=user,password=passwd)

def get_longest(names):
    nl = [len(x) for x in names]
    nl.sort()
    return nl.pop()

def tabify(x):
    x = '\t' + x
    return x

def clean_name(rule):
    # Get the current rule name
    rule_name = rule.replace('\t','')
    return rule_name

def open_rule(rule_name):
    if in_gtm:
        # We're in the GTM menu, so pull that rule. 
        try:
            rule = gtm.query_rule([rule_name])
        except Exception, e:
            print e
        print "Fetching GTM rule..."
    else:
        try:
            rule = ltm.query_rule([rule_name])
        except Exception, e:
            print e
        print "Fetching LTM rule..."
        
        #Get the current line. Assume it's been selected for open.
        try:
            rule = ltm.query_rule([rule_name])
        except Exception, e:
            print e

    #Return the a list for current buffer.
    rule = rule[0].rule_definition.splitlines()
    return rule
EOF

"""""""""""""""""""""""""""""
" Define our vim functions
"""""""""""""""""""""""""""""
function! Connect(HOST)
"Login function. Points to your favorite BigIP.
python << EOF

user,passwd = get_creds()
host = vim.eval("a:HOST")

# Our main objects to call methods against.
ltm, gtm = get_objects(host,user,passwd)

EOF
endfunction

function! PubRule(...)
python << EOF
'''Publish the rule you're working on.'''
# Default to saving rules in an LTM context.
save_gtm = False

# if an arg is passed to the Sav func, 
# see if it's gtm and save it.
if int(vim.eval("a:0")):
    arg = vim.eval("a:1")
    arg = arg.upper()
    if arg == 'GTM':
        save_gtm = True

buf = vim.current.buffer
text_rule = "\n".join(buf)
rule_name = get_name()

if save_gtm:
    ruledef = gtm.typefactory.create('GlobalLB.Rule.RuleDefinition')
else:
    ruledef = ltm.typefactory.create('LocalLB.Rule.RuleDefinition')

ruledef.rule_name = rule_name
ruledef.rule_definition = text_rule.encode('ascii')

if create_rule:
    #Create_rule is true, so we're saving for the first time.
    if save_gtm:
        try:
            gtm.create(rules = [ruledef])
            print "New Rule Saved."
            #now that we've created, switch to modify calls.
            create_rule = False
        except Exception, e:
            print e
    else:
        try:
            ltm.create(rules = [ruledef])
            print "New Rule Saved."
            #now that we've created, switch to modify calls.
            create_rule = False
        except Exception, e:
            print e
else:
    # Here we're modifying an existing rule.
    if save_gtm:
        try:
            gtm.modify_rule(rules = [ruledef])
            print "GTM rule Updated."
        except Exception, e:
            print e
    else:
        try:
            ltm.modify_rule(rules = [ruledef])
            print "LTM rule Updated."
        except Exception, e:
            print e
EOF
endfunction

"""""""""""""""""""""
function! GetRules()

python << EOF
''' Get the list of rules and render them on the left split'''

l = ltm.get_list()
g = gtm.get_list()

# Vim is utf-8 by default, so convert.
l = [x.encode('utf8') for x in l]
g = [x.encode('utf8') for x in g]

# Add tabs to allow for code folding of the menu.
l = [tabify(x) for x in l]
g = [tabify(x) for x in g]

# Prepend the section title (LTM or GTM)
l.insert(0,'LTM')
g.insert(0,'GTM')

# Build the menu with vim commands. 
vim.command(str(get_longest(l)+ 2) + 'vs _irules_')
vim.command('set shiftwidth=2')
vim.command('set tabstop=2')
vim.command('set foldmethod=indent')

#Set the buffer type for this list to 'nofile'
vim.command('set buftype=nofile')
vim.command('set cursorline')
vim.command('hi CursorLine ctermfg=black ctermbg=grey')
vim.command('hi Folded ctermfg=darkgreen')
vim.command('set foldtext=MyFoldText()')

# Set, write the buffer.
buf = vim.current.buffer
buf[:] = l + g
EOF

endfunction
"""""""""""""""""""""
function! OpenRule()
python << EOF

# Figure out if we're in the LTM or GTM menu section.
# The search will return '1' if the item above is GTM.
# Else, assume we're in LTM.

in_gtm = int(vim.eval('search("GTM","nbW")'))
raw_name = vim.current.line #The current line we're on.

rule_name = clean_name(vim.current.line)

# Delete the rule list buffer to save space. 
vim.command('bdelete')
vim.command(':e ' + rule_name + '.irul')
buf2 = vim.current.buffer
buf2[:] = [x.encode('utf8') for x in open_rule(clean_name(raw_name))]
create_rule = False
EOF
endfunction

function! NewRule()
python << EOF
'''
Simple func to toggle create_rule to true.
If the func is called, open a new blank
screen and set the filetype to irul so
syntax highlights will work.
'''

vim.command(':enew')
vim.command('set filetype=irul')
create_rule = True
EOF
endfunction


function! Partition(name)
python << EOF
'''
Switches the current partition.
'''
b2 = BIGIP(hostname=host,username=user,password=passwd,fromurl=True,wsdls=['Management.Partition'])
name = vim.eval("a:name")
b2.Management.Partition.set_active_partition(name)
print "Current partition is: %s" % b2.Management.Partition.get_active_partition()
EOF
endfunction

function! ApplyRule(virtual_server)
python << EOF
'''
Applies a rule to the VS name passed in.
'''
# Set the default priority. You can override this by doing :py rule_priority=100 for example.
rule_priority = 500 
b3 = BIGIP(hostname=host,username=user,password=passwd,fromurl=True,wsdls=['LocalLB.VirtualServer'])
v = b3.LocalLB.VirtualServer
# Get names
vs_name = vim.eval("a:virtual_server")
rule_name = get_name()

# Create types, set attrs.
rule = v.typefactory.create('LocalLB.VirtualServer.VirtualServerRule')
ruleseq = v.typefactory.create('LocalLB.VirtualServer.VirtualServerRuleSequence')
rule.rule_name = rule_name
rule.priority = rule_priority
ruleseq.item = [rule]

try: 
    v.add_rule(virtual_servers = [vs_name],rules=[ruleseq])
    print "Rule applied to: %s" % vs_name
except Exception,e:
    print e
EOF
endfunction


function! DeleteRule(...)
python << EOF
''' Deletes a rule. '''

# Get the name passed.
if int(vim.eval("a:0")) == 2:
    arg = vim.eval("a:1")
    name = vim.eval("a:2")
    if arg.upper() == 'GTM':
        del_gtm = True
else: 
    del_gtm = False
    name = vim.eval("a:1")

if del_gtm:
    ''' we're deleting a gtm rule.'''
    try: 
        gtm.delete_rule([name])
        print "GTM rule %s deleted." % name
    except Exception,e:
        print e
else:
    try: 
        ltm.delete_rule([name])
        print "LTM rule %s deleted." % name
    except Exception,e:
        print e
EOF
endfunction
