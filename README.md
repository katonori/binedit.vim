binedit.vim
======

What is this?
------
**binedit.vim** is a vim plugin enables binary editing.
By this script you can change, insert or delete binary value from vim.

This script makes a temporary file for binary editing. And the changes are committed to the original file
when you explicitly execute *BinEditCommit* command or save the changes to temporary file (if you don't prefer this
behavior you can turn off this feature by setting BinEditAutoCommit to 0).

Requirement
------
xxd command.

How to install
------
Copy *plugin* and *autoload* directory to your vim script directory.
Or type `make install` to install these scripts to `~/.vim`. 

How to use
------
* Type below in vim.

        :BinEdit

* Add alias to your shell like below. This alias automatically execute BinEdit command after loading a file.

        alias vimhex='vim -c ":BinEdit"'

Cautions
------
This script is very simple xxd wrapper script. So there are some restrictions.

* You cannot edit a text preview part.
  * This script assumes the last 16 characters in a line is a text preview part.
    Hex to text conversion will fail if you modify this part.
* You cannot edit an address part.
  * Similar to above, this script assumes the characters until ':' in a line is an address part.
    Hex to text conversion will fail if you modify this part.

Commands
------
|Name              | Description |
| ---------------- | ------------------- |
|BinEdit  | Start binary editing mode. |
|BinEditRefresh | Refresh buffer content. |
|BinEditCommit | Commit the content of the temporary file to the original file. |

Default key maps
------

### Normal mode

| Map          | Command            |
| ------------ | ------------------ |
|\<leader>r   | BinEditRefresh    |
|\<leader>c   | BinEditCommit    |

Variables
------

|Name                 | Default value     | Description |
| ------------------- | ----------------- | ----------- |
|BinEditAutoCommit  | 1            | Set 0 if you don't want to the automatic commit after saving. |

This script can be configured by changing these variables. Use *let* command to set value to these variables like below.

     let BinEditAutoCommit = 0
