using GLib;
using Pluie;

/**
 *
 */
public class Pluie.Berel.Sepline : Yaml.Object
{
    /**
     *
     */
    public string motif      { get; set; }
    /**
     *
     */
    public int    repeat     { get; set; }
    /**
     *
     */
    string? data             { internal get; internal set; }

    /**
     *
     */
    public string to_string ()
    {
        if (this.data == null) {
            StringBuilder sb = new StringBuilder("");
            for (var i = 0; i < this.repeat; i++) sb.append (this.motif);
            data = sb.str;
        }
        return this.data;
    }
}
