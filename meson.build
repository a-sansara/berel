#^# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  @software    :    berel           <https://git.pluie.org/pluie/berel>
#  @version     :    0.24
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

project('berel', ['vala', 'c'], version:'0.21')

conf = configuration_data()
conf.set('VERSION'     , meson.project_version())
conf.set('INSTALL_PATH', join_paths(get_option('prefix'), get_option('bindir')))
conf.set('DATA_PATH'   , join_paths(get_option('prefix'), get_option('datadir'), 'pluie/berel'))

configure_file(
  input : 'src/install.vala',
  output: 'install.vala',
  configuration: conf
)

subdir('src')

executable(
    meson.project_name(), 
    src_files +  [ 'build/install.vala' ], 
    install : true, 
    dependencies : [
        dependency('glib-2.0'), 
        dependency('gobject-2.0'), 
        dependency('gmodule-2.0'), 
        dependency('gio-2.0'), 
        dependency('gee-0.8'), 
        dependency('pluie-echo-0.2'), 
        dependency('pluie-yaml-0.5'), 
        meson.get_compiler('c').find_library('m', required : false)
    ]
)


