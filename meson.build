#^# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  @software    :    berel           <https://git.pluie.org/pluie/berel>
#  @version     :    0.21
#  @type        :    program
#  @date        :    2018
#  @license     :    GPLv3.0         <http://www.gnu.org/licenses/>
#  @author      :    a-Sansara       <[dev]at[pluie]dot[org]>
#  @copyright   :    pluie.org       <http://www.pluie.org>
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  This file is part of berel.
#
#  berel is free software (free as in speech) : you can redistribute it
#  and/or modify it under the terms of the GNU General Public License as
#  published by the Free Software Foundation, either version 3 of the License,
#  or (at your option) any later version.
#
#  berel is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License
#  along with berel.  If not, see <http://www.gnu.org/licenses/>.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #^#

project('berel', 'vala', 'c', version:'0.21')

cc            = meson.get_compiler('c')
dep_glib      = dependency('glib-2.0')
dep_gobject   = dependency('gobject-2.0')
dep_gmodule   = dependency('gmodule-2.0')
dep_gio       = dependency('gio-2.0')
dep_gee       = dependency('gee-0.8')
dep_echo      = dependency('pluie-echo-0.2')
dep_yaml      = dependency('pluie-yaml-0.5')
dep_m         = cc.find_library('m', required : false)
# dep_yaml      = cc.find_library('yaml', required : true)

version       = meson.project_version()
bindir        = join_paths(get_option('prefix'), get_option('bindir'))
datadir       = join_paths(get_option('prefix'), get_option('datadir'), 'pluie/berel')
libdir        = join_paths(get_option('prefix'), get_option('libdir'), 'pkgconfig')
incdir        = join_paths(get_option('prefix'), get_option('includedir'), 'pluie')

conf          = configuration_data()
conf.set('VERSION'     , version)
conf.set('INSTALL_PATH', bindir)
conf.set('DATA_PATH'   , datadir)

configure_file(
  input: 'install.vala.in',
  output: 'install.vala',
  configuration: conf
)

sources = [
    'build/install.vala',
    'src/Pluie/Berel.App.vala',
    'src/Pluie/Berel.Comment.vala',
    'src/Pluie/Berel.HeaderDef.vala',
    'src/Pluie/Berel.Key.vala',
    'src/Pluie/Berel.Meta.vala',
    'src/Pluie/Berel.Sepline.vala',
    'main.vala',
]

executable('berel', sources, install : true, dependencies : [dep_glib, dep_gobject, dep_gmodule, dep_gio, dep_gee, dep_echo, dep_yaml, dep_m])


