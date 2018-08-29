/*^* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 *  @software    :    berel           <https://git.pluie.org/pluie/berel>
 *  @version     :    0.24
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
    public string get_line (string data, bool disabled = false)
    {
        return "%s%s".printf (disabled ? "" : this.begin, data).chomp ();
    }
}
