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
public class Pluie.Berel.App
{
    /**
     *
     */
    public bool done    { get; internal set; }
    /**
     *
     */
    string      pwd;
    /**
     *
     */
    Berel.Meta  meta;
    /**
     *
     */
    Io.Reader   reader;
    /**
     *
     */
    Io.Writter  writter;

    /**
     *
     */
    public App(string? path = null)
    {
        of.title ("Berel", Pluie.Berel.VERSION, "a-sansara");
        if (this.load_config(path)) {
            foreach (var header in this.meta.headers) {
                this.write_header (header);
            }
            this.done = true;
        }
    }

    /**
     *
     */
    private bool load_config (string? path = null)
    {
        bool done  = false;
        this.pwd   = GLib.Environment.get_current_dir ();
        var config = new Yaml.Config (Path.build_filename (path != null ? path : pwd, ".berel.yml"), false);
        var root   = config.root_node ();
        root.name  = Path.get_basename (pwd)+"/.berel.yml";
        Yaml.Dumper.show_yaml_string (root);
        if ((done = root != null)) {
            this.meta = (Berel.Meta) Yaml.Builder.from_node (root.first ());
        }
        return done;
    }

    /**
     *
     */
    private void write_header (Berel.HeaderDef header)
    {
        of.action ("write headers from header def", header.yaml_name);
        var hasHeader = false;
        string? data  = null;
        string? path  = null;
        foreach (var name in header.file) {
            path = Path.build_filename(this.pwd, name);
            data = this.get_write_content(path, header);
            this.write_file (path, data);
        }
        foreach (var name in header.dir) {
            path = Path.build_filename(this.pwd, name);
            this.write_dir (path, header);
        }
    }

    /**
     *
     */
    private void write_dir (string path,  HeaderDef header)
    {
        of.echo (" > reading directory %s".printf (path));
        string? dname = null;
        string? data  = null;
        Dir     dir   = Dir.open (path, 0);
        while ((dname = dir.read_name ()) != null) {
            string? p = Path.build_filename (path, dname);
            if (FileUtils.test (p, FileTest.IS_DIR))
                this.write_dir (p, header);
            else {
                data = this.get_write_content(p, header, true);
                this.write_file (p, data);
            }
        }
        of.echo (" < directory %s".printf (path));
    }

    /**
     *
     */
    private bool write_file (string path, string? data = null)
    {
        bool done = false;
        of.echo (" updating file : %s".printf (path));
        if (data != null && data.length > 0) {
            this.writter = new Io.Writter (path, true);
            done = this.writter.write (data.data);
        }
        of.state (done);
        return done;
    }

    /**
     *
     */
    private bool match_extension (string path, Gee.ArrayList<string> extlist)
    {
        foreach (var ext in extlist) {
            if (ext == path.substring (-ext.length)) return true;
        }
        return extlist.size == 0;
    }

    /**
     *
     */
    private string get_write_content (string path, HeaderDef header, bool from_dir = false)
    {
        bool proceed      = !from_dir || this.match_extension (path, header.extension);
        StringBuilder sb  = new StringBuilder ();
        if (proceed) {
            string[]      bfs = new string[header.startline];
            string?       s   = null;
            bool headbegin    = false;
            bool headend      = false;
            this.reader       = new Io.Reader(path);
            this.reader.rewind (new Io.StreamLineMark (0, 0));
            int line          = 1;
            int firstempty    = -1;
            while (this.reader.readable && (s = this.reader.read ()) != null) {
                if (header.startline > line) bfs[header.startline-line] = s;
                else if (line == header.startline) {
                    headbegin = s.index_of (header.comment.start) == 0;
                    if (!headbegin) {
                        if (firstempty == -1 && s=="") firstempty = line;
                        sb.append ("%s\n".printf (s));
                    }
                }
                else {
                    if (!headbegin || headend || s.index_of (header.comment.end) != -1) {
                        if (headbegin && !headend) headend = true;
                        else {
                            if (headbegin && headend && firstempty == -1 && s=="") firstempty = line;
                            sb.append ("%s\n".printf (s));
                        }
                    }
                }
                line++;
            }
            if (sb.str.length > 0) {
                sb.prepend ("%s%s".printf(this.meta.get_template(header), firstempty != -1 ? "" : "\n"));
                if (bfs.length > 0) {
                    foreach (var bs in  bfs) if (bs != null) sb.prepend ("%s\n".printf (bs));
                }
            }
        }
        return sb.str;
    }
}
