using GLib;
using Gee;
using Pluie;

int main (string[] args)
{
    Echo.init(false);

    var path = "./resources/berel.yml";
    of.echo (path);
    var done = false;

    of.title ("Pluie Yaml Library", Pluie.Yaml.VERSION, "a-sansara");
    Pluie.Yaml.DEBUG = true;
    var config = new Yaml.Config (path, true);
    var root   = config.root_node ();
    if ((done = root != null)) {
        root.display_childs ();
        var berel = (Berel.Meta) Yaml.Builder.from_node (root.first ());
        of.echo("software  : %s    %s".printf (berel.keys.software.name, berel.keys.software.address));
        of.echo("version   : %s".printf (berel.keys.version));
        of.echo("type      : %s".printf (berel.keys.ltype));
        of.echo("date      : %s".printf (berel.keys.date));
        of.echo("license   : %s    %s".printf (berel.keys.license.name, berel.keys.license.address));
        of.echo("author    : %s    %s".printf (berel.keys.author.name, berel.keys.author.address));
        of.echo("copyright : %s    %s".printf (berel.keys.copyright.name, berel.keys.copyright.address));
        print (berel.tpl);
        of.echo ();
        print(berel.get_template ("vala"));
    }
    of.rs (done);
    of.echo ();
    return (int) done;

}

