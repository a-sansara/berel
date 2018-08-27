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
    public Berel.Keys                       keys    { get; internal set; }
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
                }
            }
        }
        else {
            var obj = Yaml.Builder.from_node(node, type);
             if (name == "keys") {
                this.set (node.name, (Berel.Keys ) obj);
            }
            else {
                this.set (node.name, obj);
            }
        }
    }

    /**
     *
     */
    public string get_template (string type)
    {
        var headerdef    = this.get_header_by_type (type);
        var count        = 1;
        this.tpl_replace_var (headerdef);
        StringBuilder sb = new StringBuilder ("");
        foreach (string line in this.tpl.split ("\\n")) {
            if (count == 1) {
//~                 sb.append (this.comment.start
            }
            count++;
        }
        return "";
    }

    /**
     *
     */
    public void tpl_replace_var (HeaderDef hd)
    {
        MatchInfo? mi = null;
        Regex     reg = new Regex ("\\^([^\\^]+)\\^");
        if (reg.match (this.tpl, 0, out mi)) {
            this.replacing (mi.fetch (1), hd);
            while (mi.next ()) {;
                this.replacing (mi.fetch (1), hd);
            }
        }
        foreach (var entry in this.varlist.entries) {
            if (entry.value.length > 0) {
                this.tpl = this.tpl.replace("^%s^".printf (entry.key), entry.value);
            }
        }
        var s = this.tpl.split("\\n");
        foreach (unowned string str in s) {
            print ("%s\n", hd.comment.get_line(str));
        }
    }

    /**
     *
     */
    private void replacing (string key, HeaderDef hd)
    {
        if (!this.varlist.has_key (key)) {
            switch (key) {
                case "sepline" :
                    this.varlist.set (key, hd.sepline.to_string ());
                    break;
                case "keys" :
                    this.varlist.set (key, this.keys.get_all (hd));
                    break;
                default :
                    this.varlist.set (key, this.keys.replace_var(key));
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
}
