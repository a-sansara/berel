# Berel

**berel** is a small program in vala whose purpose is to illustrate the use of the **pluie-yaml** lib 
while allowing to configure and write a common header to all the source files of a project

## usage

to use **berel** in your project you need a yaml configuration (.berel.yml) file at the root of your project.
then `cd` to your project and just execute **berel**.


## License

GNU GPL v3


## Prerequisites

`valac meson ninja libyaml glib gio gobject gmodule gee pluie-echo pluie-yaml`

see https://git.pluie.org/pluie/libpluie-echo in order to install pluie-echo-0.2 pkg     
see https://git.pluie.org/pluie/lib-yaml in order to install pluie-yaml-0.5 pkg


## Install

git clone the project then cd to project directory and do :

```
meson --prefix=/usr ./ build
sudo ninja install -C build
```

or simply execute

```
build.sh
```

## configuration

configuration file is defined with a root **meta** mapping node which contains three mapping child node :

 * the keys
 * the headers definition
 * the tpl data

### configuring keys

the **keys** node is a mapping node with any single pair node (except with name **keys** & **sepline**).  
scalar values are also free but you need to know that data are split with ';' as delimiter
to produce a third column

```yaml
%YAML 1.2
%TAG !v! tag:pluie.org,2018:vala/
---
!v!Pluie.Berel.Meta meta :
  keys :
    software    : berel; <https://git.pluie.org/pluie/berel>
    version     : 0.21
    type        : program
    date        : 2018
    license     : GPLv3.0; <http://www.gnu.org/licenses/>
    author      : a-Sansara; <[dev]at[pluie]dot[org]>
    copyright   : pluie.org; <http://www.pluie.org>
```
with **`^keys^`** in the **`tpl`** node (see below), it will  produce :

```
@software    :    berel           <https://git.pluie.org/pluie/berel>
@version     :    0.21
@type        :    program
@date        :    2018
@license     :    GPLv3.0         <http://www.gnu.org/licenses/>
@author      :    a-Sansara       <[dev]at[pluie]dot[org]>
@copyright   :    pluie.org       <http://www.pluie.org>
```

this part allow using defined keys as variables in the template :

**`^license.name^`**     will produce : `GPLv3.0`   
**`^license.address^`**  will produce : `<http://www.gnu.org/licenses/>`  

### configuring headers

`headers` node is a sequence of `Berel.HeaderDef` mapping node

```yaml
  headers :
    - sh :

        file        :             # sequence of scalar, add any file
            - build.sh

        startline   : 2           # to embed shebang before header tpl

        sepline     :             # a separator line build with a repeating motif
            motif       : "# "    
            repeat      : 40

        comment     :             # comment definition to use. it is recommended 
            start       : "#^#"   # to add a special character in addition to distinguish 
            end         : "#^#"   # the comment from the source file of the berel header comment.
            begin       : "#  "   # begin is the motif to prepend to each line in the template
    - vala :
        dir         :             # sequence of scalar, berel will inspect directory
            - src                 # recursively and treat any file matching the defined extensions
        extension   :             # sequence of scalar, define your extensions.
            - .vala
        sepline     :
            motif       : " *"
            repeat      : 40
        comment     :
            start       : "/*^"
            end         : "^*/"
            begin       : " *  "
```

### configuring template

you can use variables by enclosing name with **'^'**

**^sepline^** is a reserved variable.  
**sepline** will act as a line separtor. for example with the previous `vala` header definition it will produce :

```
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
```
for `sh` header definition, it will use 'sharp' instead of 'star' symbol. 

`^keys^` is another reserved variable.  
it will produce all the defined keys in the `keys` node (first part config)

you can use other variables with name  matching your `keys`.  
theses variables will act as a Berel.Key :  
**`$keyName.name`** : first part of scalar value  
**`$keyName.address`** : second part of scalar value (after semicolon)

example :

```yml
  tpl : |
    ^sepline^

    ^keys^

    ^sepline^

    This file is part of ^software.name^.

    ^software.name^ is free software (free as in speech) : you can redistribute it
    and/or modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation, either version 3 of the License,
    or (at your option) any later version.

    ^software.name^ is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
    more details.

    You should have received a copy of the GNU General Public License
    along with ^software.name^.  If not, see ^license.address^.

    ^sepline^
```

the final header for vala files will be :

```vala
/*^* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 *  @software    :    berel           <https://git.pluie.org/pluie/berel>
 *  @version     :    0.21
 *  @type        :    program
 *  @date        :    2018
 *  @license     :    GPLv3.0         <http://www.gnu.org/licenses/>
 *  @author      :    a-Sansara       <[dev]at[pluie]dot[org]>
 *  @copyright   :    pluie.org       <http://www.pluie.org>
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 *  This file is part of berel.
 *
 *  berel is free software (free as in speech) : you can redistribute it
 *  and/or modify it under the terms of the GNU General Public License as
 *  published by the Free Software Foundation, either version 3 of the License,
 *  or (at your option) any later version.
 *
 *  berel is distributed in the hope that it will be useful, but WITHOUT
 *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 *  more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with berel.  If not, see <http://www.gnu.org/licenses/>.
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *^*/
```
