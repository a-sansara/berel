using GLib;
using Pluie;
/**
 *
 */
public class Pluie.Berel.Keys : Yaml.Object
{
    /**
     *
     */
    public Berel.Key software      { get; internal set; }
    /**
     *
     */
    public string    version       { get; internal set; }  
    /**
     *
     */
    public string    ltype         { get; internal set; }  
    /**
     *
     */
    public string    date          { get; internal set; }  
    /**
     *
     */
    public Berel.Key license       { get; internal set; }  
    /**
     *
     */
    public Berel.Key author        { get; internal set; }  
    /**
     *
     */
    public Berel.Key copyright     { get; internal set; }  

    /**
     *
     */
    public string get_all (HeaderDef hd)
    {
        var properties = this.get_class ().list_properties;
        Berel.Key?  ck = null;
        string?     cs = null;
        foreach (var p in properties) {
            if (p.value_type.is_a(typeof (Berel.Key))) {
                
            }
        }
        foreach 
        var str = """@software :    %15s    %s
@version  :    %s    %s
@type     :    %s
@date     :    %s
        ".printf (
        """;
        
    }

    /**
     *
     */
    public string replace_var (string varname)
    {
        string val = "";
        var list = varname.split(".", 2);
        if (list.length == 1) {
            if (this.get_class ().find_property (varname) != null) {
                this.get(varname, out val);
            }
            
        }
        else {
            Berel.Key? k = null; 
            this.get(list[0], out k);
            if (k != null) {
                if (k.get_class ().find_property (list[1]) != null) {
                    k.get(list[1], out val);
                }
            }
        }
        return val;
    }
}
