this is sort of working.  not enough to get all the way off the ground, but it bounces the vehicle

behavior is the same regardless of vehicle's mass, so that is be properly compensated

it's not great at applying at center of mass (impulse also applies a pitch torque)

also, impulse is strongest when vehicle is upright, weakest when it's on its back


```log
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] ACTIVE — mass=500 (real)  hover height=6.0 above ground
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1498.0,1340.1,23.4) groundZ=23.4 targetZ=29.4 errZ=6.00 dv=(-0.00,-0.00,3.15) antiG=0.148 vel=(0.0,0.0,0.0) mass=500
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1498.0,1340.1,23.4) groundZ=23.4 targetZ=29.4 errZ=6.00 dv=(0.02,0.04,2.08) antiG=0.135 vel=(-0.0,-0.1,0.7) mass=500
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1498.0,1340.1,23.5) groundZ=23.5 targetZ=29.5 errZ=6.00 dv=(0.03,0.11,-1.68) antiG=0.145 vel=(-0.1,-0.3,3.2) mass=500
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1498.0,1340.1,23.5) groundZ=23.5 targetZ=29.5 errZ=6.00 dv=(0.07,0.20,-5.00) antiG=0.148 vel=(-0.1,-0.4,5.4) mass=500
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1498.0,1340.1,23.5) groundZ=23.5 targetZ=29.5 errZ=6.00 dv=(-0.03,-0.02,3.89) antiG=0.147 vel=(0.1,0.0,-0.5) mass=500
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1498.0,1340.1,23.5) groundZ=23.5 targetZ=29.5 errZ=6.00 dv=(0.28,0.31,2.81) antiG=0.149 vel=(-0.6,-0.7,0.2) mass=500
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1498.0,1340.1,23.6) groundZ=23.6 targetZ=29.6 errZ=6.00 dv=(-0.05,-0.10,-3.34) antiG=0.148 vel=(0.1,0.2,4.3) mass=500
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1498.0,1340.1,23.7) groundZ=23.7 targetZ=29.7 errZ=6.00 dv=(-0.06,-0.05,-1.53) antiG=0.145 vel=(0.1,0.1,3.1) mass=500
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1498.0,1340.1,23.7) groundZ=23.7 targetZ=29.7 errZ=6.00 dv=(0.05,-0.00,2.65) antiG=0.148 vel=(-0.1,0.0,0.3) mass=500
[2026-07-17 19:28:18 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1498.0,1340.1,23.7) groundZ=23.7 targetZ=29.7 errZ=6.00 dv=(0.08,0.02,3.53) antiG=0.149 vel=(-0.2,-0.0,-0.3) mass=500
[2026-07-17 19:28:29 UTC-05:00] [6720] [HoverVehicleTester] Deactivated
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] ACTIVE — mass=2690 (real)  hover height=6.0 above ground
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1534.4,2010.4,18.4) groundZ=18.4 targetZ=24.4 errZ=6.00 dv=(-0.00,-0.00,3.13) antiG=0.132 vel=(0.0,0.0,0.0) mass=2690
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1534.4,2010.4,18.4) groundZ=18.4 targetZ=24.4 errZ=6.00 dv=(0.02,0.02,-1.51) antiG=0.127 vel=(-0.0,-0.0,3.1) mass=2690
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1534.4,2010.4,18.5) groundZ=18.5 targetZ=24.5 errZ=6.00 dv=(-0.00,-0.00,-0.00) antiG=0.123 vel=(0.0,0.0,2.1) mass=2690
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1534.4,2010.4,18.5) groundZ=18.5 targetZ=24.5 errZ=6.00 dv=(0.01,0.00,1.00) antiG=0.127 vel=(-0.0,-0.0,1.4) mass=2690
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1534.4,2010.4,18.5) groundZ=18.5 targetZ=24.5 errZ=6.00 dv=(0.00,0.00,0.90) antiG=0.125 vel=(-0.0,-0.0,1.5) mass=2690
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1534.4,2010.4,18.5) groundZ=18.5 targetZ=24.5 errZ=6.00 dv=(0.00,0.01,-0.17) antiG=0.125 vel=(-0.0,-0.0,2.2) mass=2690
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1534.4,2010.4,18.6) groundZ=18.6 targetZ=24.6 errZ=6.00 dv=(-0.00,-0.00,-0.82) antiG=0.127 vel=(0.0,0.0,2.6) mass=2690
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1534.4,2010.4,18.6) groundZ=18.6 targetZ=24.6 errZ=6.00 dv=(-0.03,-0.00,-0.42) antiG=0.122 vel=(0.1,0.0,2.4) mass=2690
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1534.4,2010.4,18.6) groundZ=18.6 targetZ=24.6 errZ=6.00 dv=(-0.00,-0.00,0.66) antiG=0.124 vel=(0.0,0.0,1.6) mass=2690
[2026-07-17 19:30:41 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1534.4,2010.4,18.6) groundZ=18.6 targetZ=24.6 errZ=6.00 dv=(0.00,-0.00,1.33) antiG=0.122 vel=(-0.0,0.0,1.2) mass=2690
[2026-07-17 19:31:07 UTC-05:00] [6720] [HoverVehicleTester] Deactivated
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] ACTIVE — mass=2690 (real)  hover height=6.0 above ground
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1546.2,2011.2,18.4) groundZ=18.4 targetZ=24.4 errZ=6.00 dv=(-0.00,-0.00,3.15) antiG=0.150 vel=(0.0,0.0,0.0) mass=2690
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1546.2,2011.2,18.4) groundZ=18.4 targetZ=24.4 errZ=6.00 dv=(0.00,-0.00,2.28) antiG=0.127 vel=(-0.0,0.0,0.6) mass=2690
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1546.2,2011.2,18.4) groundZ=18.4 targetZ=24.4 errZ=6.00 dv=(0.02,-0.02,-1.18) antiG=0.139 vel=(-0.0,0.1,2.9) mass=2690
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1546.2,2011.2,18.5) groundZ=18.5 targetZ=24.5 errZ=6.00 dv=(0.03,-0.02,-2.80) antiG=0.141 vel=(-0.1,0.1,4.0) mass=2690
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1546.2,2011.2,18.5) groundZ=18.5 targetZ=24.5 errZ=6.00 dv=(0.01,-0.02,-0.02) antiG=0.137 vel=(-0.0,0.0,2.1) mass=2690
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1546.2,2011.2,18.5) groundZ=18.5 targetZ=24.5 errZ=6.00 dv=(0.03,-0.04,1.55) antiG=0.140 vel=(-0.1,0.1,1.1) mass=2690
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1546.2,2011.2,18.6) groundZ=18.6 targetZ=24.6 errZ=6.00 dv=(0.02,-0.02,0.94) antiG=0.144 vel=(-0.0,0.0,1.5) mass=2690
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1546.2,2011.2,18.6) groundZ=18.6 targetZ=24.6 errZ=6.00 dv=(-0.01,0.01,-0.92) antiG=0.135 vel=(0.0,-0.0,2.7) mass=2690
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1546.2,2011.2,18.6) groundZ=18.6 targetZ=24.6 errZ=6.00 dv=(-0.01,0.02,-1.31) antiG=0.139 vel=(0.0,-0.1,3.0) mass=2690
[2026-07-17 19:31:21 UTC-05:00] [6720] [HoverVehicleTester] DIAG pos=(-1546.2,2011.2,18.7) groundZ=18.7 targetZ=24.7 errZ=6.00 dv=(-0.01,0.03,-1.10) antiG=0.142 vel=(0.0,-0.1,2.8) mass=2690
[2026-07-17 19:31:41 UTC-05:00] [6720] [HoverVehicleTester] Deactivated
```