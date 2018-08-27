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
