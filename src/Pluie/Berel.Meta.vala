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
/**
 *
 */
public class Pluie.Berel.Meta : Yaml.Object
{
    /**
     *
     */
    public Gee.ArrayList<Berel.Key>         keys    { get; internal set; }
    /**
     *
     */
    public Gee.ArrayList<Berel.HeaderDef>   headers { get; internal set; }
    /**
     *
     */
    public string                           tpl     { get; internal set; }
    /**
     *
     */
    private Gee.HashMap<string, string>     varlist { get; internal set; }

    /**
     *
     */
    static construct
    {
        Yaml.Register.add_type (
            typeof (Berel.Meta),
            typeof (Gee.ArrayList)
        );
    }

    /**
     *
     */
    protected override void yaml_construct ()
    {
        this.headers = new Gee.ArrayList<Berel.HeaderDef> ();
        this.keys    = new Gee.ArrayList<Berel.Key> ();
        this.varlist = new Gee.HashMap<string, string> ();
        Yaml.Register.add_namespace("Gee", "Pluie.Berel");
        Dbg.msg ("%s (%s) instantiated".printf (this.yaml_name, this.get_type().name ()), Log.LINE, Log.FILE);
    }

    /**
     *
     */
    public override void populate_from_node (string name, GLib.Type type, Yaml.Node node) {
        if (type == typeof (Gee.ArrayList)) {
            foreach (var child in node) {
                switch (name) {
                    case "headers":
                        this.headers.add((Berel.HeaderDef) Yaml.Builder.from_node (child, typeof (Berel.HeaderDef)));
                        break;
                    case "keys":
                        this.keys.add (new Berel.Key.with_node(child));
                        break;
                }
            }
        }
        else {
            this.set (node.name, Yaml.Builder.from_node(node, type));
        }
    }

    /**
     *
     */
    public string get_template (HeaderDef hd)
    {
        var count        = 1;
        StringBuilder sb = new StringBuilder();
        var s            = this.tpl_replace_var (hd);
        foreach (unowned string str in s.split("\\n")) {
            if (count++ == 1) {
                sb.append("%s\n".printf (hd.comment.start+str.substring (hd.comment.start.length)));
            }
            else {
                sb.append("%s\n".printf (hd.comment.get_line(str, str==hd.sepline.to_string ())));
            }
        }
        return "%s%s\n".printf (sb.str.substring (0, sb.str.length - 3 - hd.comment.end.length), hd.comment.end);
    }

    /**
     *
     */
    public string tpl_replace_var (HeaderDef hd)
    {
        string    str = this.tpl;
        this.varlist  = new Gee.HashMap<string, string> ();
        try {
            MatchInfo? mi = null;
            Regex     reg = new Regex ("\\^([^\\^]+)\\^");
            if (reg.match (str, 0, out mi)) {
                this.define_var (mi.fetch (1), hd);
                while (mi.next ()) {;
                    this.define_var (mi.fetch (1), hd);
                }
            }
            foreach (var entry in this.varlist.entries) {
                if (entry.value.length > 0) {
                    str = str.replace("^%s^".printf (entry.key), (entry.key == "sepline" ? "" : "")+entry.value);
                }
            }
        }
        catch (GLib.RegexError e) {
            of.error (e.message);
        }
        return str;
    }

    /**
     *
     */
    private void define_var (string key, HeaderDef hd)
    {
        if (!this.varlist.has_key (key)) {
            switch (key) {
                case "sepline" :
                    this.varlist.set (key, hd.sepline.to_string ());
                    break;
                case "keys" :
                    this.varlist.set (key, this.get_all_keys (hd));
                    break;
                default :
                    this.varlist.set (key, this.replace_var(key));
                    break;
            }
        }
    }

    /**
     *
     */
    public Berel.HeaderDef? get_header_by_type (string type)
    {
        Berel.HeaderDef? hd = null;
        foreach (var def in this.headers) {
            if (def.yaml_name == type) {
                hd = def;
                break;
            }
        }
        return hd;
    }

    /**
     *
     */
    public string get_all_keys (HeaderDef hd)
    {
        int len  = 0;
        int lenk = 0;
        StringBuilder sb = new StringBuilder ();
        foreach (var bk in this.keys) {
            if (bk.yaml_name.length > lenk) lenk = bk.yaml_name.length;
            if (bk.name.length > len) len = bk.name.length;
        }
        int count = 0;
        foreach (var bk in this.keys) {
            sb.append (hd.comment.get_line("@%s%s :    %s%s%s".printf (
                bk.yaml_name, 
                string.nfill(lenk+2-bk.yaml_name.length, ' '),
                bk.name,
                string.nfill(len+2-bk.name.length, ' '),
                bk.address != null ? "    %s".printf (bk.address) : ""
            ),count++ == 0));
            sb.append ("\n");
        }
        return sb.str;
    }

    /**
     *
     */
    public string replace_var (string varname)
    {
        string val = "";
        var list = varname.split(".", 2);
        foreach (var k in this.keys) {
            if (k.yaml_name == list[0]) {
                val = list.length == 1 || list[1] == "name" ? k.name : k.address;
            }
        }
        return val;
    }
}
