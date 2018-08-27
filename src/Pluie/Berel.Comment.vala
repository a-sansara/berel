using GLib;
using Pluie;
/**
 *
 */
public class Pluie.Berel.Comment : Yaml.Object
{
    /**
     *
     */
    public string start      { get; set; }
    /**
     *
     */
    public string end        { get; set; } 
    /**
     *
     */
    public string begin      { get; set; }

    /**
     *
     */
    public bool match_start (string data)
    {
        return data.index_of (this.start) == 0;
    }

    /**
     *
     */
    public bool match_end (string data)
    {
        return data.last_index_of (this.end) == data.length - begin.length;
    }

    /**
     *
     */
    public string get_line (string data)
    {
        return "%s%s".printf (this.begin, data);
    }
}
