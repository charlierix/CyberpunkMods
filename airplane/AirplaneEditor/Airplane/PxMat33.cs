using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Airplane
{
    // https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PxShared/include/foundation/PxMat33.h

    /// <summary>
    /// This is a 3x3 matrix
    /// </summary>
    /// <remarks>
    /// Some clarifications, as there have been much confusion about matrix formats etc in the past.
    /// 
    /// Short:
    /// - Matrix have base vectors in columns (vectors are column matrices, 3x1 matrices).
    /// - Matrix is physically stored in column major format
    /// - Matrices are concaternated from left
    /// 
    /// Long:
    /// Given three base vectors a, b and c the matrix is stored as
    /// 
    /// |a.x b.x c.x|
    /// |a.y b.y c.y|
    /// |a.z b.z c.z|
    /// 
    /// Vectors are treated as columns, so the vector v is
    /// 
    /// |x|
    /// |y|
    /// |z|
    /// 
    /// And matrices are applied _before_ the vector (pre-multiplication)
    /// v' = M*v
    /// 
    /// |x'|   |a.x b.x c.x|   |x|   |a.x*x + b.x*y + c.x*z|
    /// |y'| = |a.y b.y c.y| * |y| = |a.y*x + b.y*y + c.y*z|
    /// |z'|   |a.z b.z c.z|   |z|   |a.z*x + b.z*y + c.z*z|
    /// 
    /// 
    /// Physical storage and indexing:
    /// To be compatible with popular 3d rendering APIs (read D3d and OpenGL)
    /// the physical indexing is
    /// 
    /// |0 3 6|
    /// |1 4 7|
    /// |2 5 8|
    /// 
    /// index = column*3 + row
    /// 
    /// which in C++ translates to M[column][row]
    /// 
    /// The mathematical indexing is M_row,column and this is what is used for _-notation
    /// so _12 is 1st row, second column and operator(row, column)!
    /// </remarks>
    public record PxMat33
    {
        // the three base vectors
        public Vector3D column0 { get; init; }
        public Vector3D column1 { get; init; }
        public Vector3D column2 { get; init; }

        /// <summary>
        /// Construct from diagonal, off-diagonals are zero
        /// </summary>
        public static PxMat33 createDiagonal(Vector3D diag)
        {
            return new PxMat33()
            {
                column0 = new Vector3D(diag.X, 0, 0),
                column1 = new Vector3D(0, diag.Y, 0),
                column2 = new Vector3D(0, 0, diag.Z),
            };
        }

        public static PxMat33 from_rot(Quaternion q)
        {
            // hopefully their quaternions are built the same as wpf's

            double x = q.X;
            double y = q.Y;
            double z = q.Z;
            double w = q.W;

            double x2 = x + x;
            double y2 = y + y;
            double z2 = z + z;

            double xx = x2 * x;
            double yy = y2 * y;
            double zz = z2 * z;

            double xy = x2 * y;
            double xz = x2 * z;
            double xw = x2 * w;

            double yz = y2 * z;
            double yw = y2 * w;
            double zw = z2 * w;

            return new PxMat33()
            {
                column0 = new Vector3D(1d - yy - zz, xy + zw, xz - yw),
                column1 = new Vector3D(xy - zw, 1d - xx - zz, yz + xw),
                column2 = new Vector3D(xz + yw, yz - xw, 1d - xx - yy),
            };
        }

        #region Operator Overloads

        // Add
        public static PxMat33 operator +(PxMat33 mat, PxMat33 other)
        {
            return new PxMat33()
            {
                column0 = mat.column0 + other.column0,
                column1 = mat.column1 + other.column1,
                column2 = mat.column2 + other.column2
            };
        }

        // Subtract
        public static PxMat33 operator -(PxMat33 mat, PxMat33 other)
        {
            return new PxMat33()
            {
                column0 = mat.column0 - other.column0,
                column1 = mat.column1 - other.column1,
                column2 = mat.column2 - other.column2
            };
        }

        // Scalar multiplication
        public static PxMat33 operator *(PxMat33 mat, double scalar)
        {
            return new PxMat33()
            {
                column0 = mat.column0 * scalar,
                column1 = mat.column1 * scalar,
                column2 = mat.column2 * scalar,
            };
        }

        // Matrix vector multiplication (returns 'this->transform(vec)')
        public static Vector3D operator *(PxMat33 mat, Vector3D vec)
        {
            return transform(mat, vec);
        }

        // Matrix multiplication
        public static PxMat33 operator *(PxMat33 mat, PxMat33 other)
        {
            // Rows from this <dot> columns from other
            // column0 = transform(other.column0) etc
            return new PxMat33()
            {
                column0 = transform(mat, other.column0),
                column1 = transform(mat, other.column1),
                column2 = transform(mat, other.column2),
            };
        }

        #endregion

        public double this[int col, int row]
        {
            get
            {
                Vector3D vec;
                switch (col)
                {
                    case 0:
                        vec = column0;
                        break;

                    case 1:
                        vec = column1;
                        break;

                    case 2:
                        vec = column2;
                        break;

                    default:
                        throw new ArgumentOutOfRangeException($"Invalid column: {col}");
                }

                switch (row)
                {
                    case 0:
                        return vec.X;

                    case 1:
                        return vec.Y;

                    case 2:
                        return vec.Z;

                    default:
                        throw new ArgumentOutOfRangeException($"Invalid row: {row}");
                }
            }
        }

        #region Public Methods

        // Get transposed matrix
        public PxMat33 getTranspose()
        {
            return new PxMat33()
            {
                column0 = new Vector3D(column0.X, column1.X, column2.X),
                column1 = new Vector3D(column0.Y, column1.Y, column2.Y),
                column2 = new Vector3D(column0.Z, column1.Z, column2.Z),
            };
        }

        #endregion

        #region Private Methods

        // Transform vector by matrix, equal to v' = M*v
        private static Vector3D transform(PxMat33 mat, Vector3D other)
        {
            return (mat.column0 * other.X) + (mat.column1 * other.Y) + (mat.column2 * other.Z);
        }

        #endregion
    }
}
