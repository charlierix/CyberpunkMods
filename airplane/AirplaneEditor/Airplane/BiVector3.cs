using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Airplane
{
    public struct BiVector3
    {
        public Vector3D p;
        public Vector3D q;

        public BiVector3(Vector3D force, Vector3D torque)
        {
            p = force;
            q = torque;
        }

        public static BiVector3 operator +(BiVector3 a, BiVector3 b)
        {
            return new BiVector3(a.p + b.p, a.q + b.q);
        }

        public static BiVector3 operator *(double f, BiVector3 a)
        {
            return new BiVector3(f * a.p, f * a.q);
        }

        public static BiVector3 operator *(BiVector3 a, double f)
        {
            return f * a;
        }
    }
}
