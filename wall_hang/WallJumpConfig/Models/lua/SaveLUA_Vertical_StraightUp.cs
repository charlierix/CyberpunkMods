﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WallJumpConfig.Models.lua
{
    public record SaveLUA_Vertical_StraightUp
    {
        public SaveLUA_KeyValue[] vert_percent { get; init; }

        public SaveLUA_KeyValue[] percent_vert_whenup { get; init; }
        public SaveLUA_KeyValue[] percent_horz_whenup { get; init; }

        public double strength { get; init; }
        public SaveLUA_KeyValue[] percent_at_speed { get; init; }
    }
}
