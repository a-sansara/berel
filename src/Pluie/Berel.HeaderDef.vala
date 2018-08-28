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

using GLib;
using Pluie;

public class Pluie.Berel.HeaderDef : Yaml.Object
{
    public Gee.ArrayList<string> file      { get; set; }
    public Gee.ArrayList<string> dir       { get; set; }
    public int                   startline { get; set; }
    public Berel.Sepline         sepline   { get; set; }
    public Gee.ArrayList<string> extension { get; set; }
    public Berel.Comment         comment   { get; set; }

    /**
     *
     */
    static construct
    {
        Yaml.Register.add_type (
            typeof (Berel.HeaderDef),
            typeof (Gee.ArrayList)
        );
    }

    /**
     *
     */
    protected override void yaml_construct ()
    {
        this.file      = new Gee.ArrayList<string> ();
        this.extension = new Gee.ArrayList<string> ();
        this.dir       = new Gee.ArrayList<string> ();
    }

    /**
     *
     */
    public override void populate_from_node (string name, GLib.Type type, Yaml.Node node) {
        if (type == typeof (Gee.ArrayList)) {
            foreach (var child in node) {
                switch (name) {
                    case "extension":
                        this.extension.add(child.data);
                        break;
                    case "file":
                        this.file.add(child.data);
                        break;
                    case "dir":
                        this.dir.add(child.data);
                        break;
                }
            }
        }
        else {
            var obj = Yaml.Builder.from_node(node, type);
            this.set (node.name, obj);
        }
    }
}
