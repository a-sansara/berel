using GLib;
using Gee;
using Pluie;

int main (string[] args)
{
    Echo.init(false);
    var done = false;

    var app  = new Berel.App();
    done =  app!=null && app.done;

    of.rs (done);
    of.echo ();
    return (int) done;
}

